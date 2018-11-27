module PrivateS3
  extend ActiveSupport::Concern

  included do
    # def self.has_private_s3(*args)
    #   define_method("has_private_s3") { args }
    # end
    # has_private_s3

    def service
      @service ||= Publishers::Service::PrivateS3Service.new
    end


    def self.has_private_s3(name, dependent: :purge_later)
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}
          @active_storage_attached_#{name} ||= ActiveStorage::Attached::One.new("#{name}", self, dependent: #{dependent == :purge_later ? ":purge_later" : "false"})
        end

        def #{name}=(attachable)
          #{name}.attach(attachable)
        end
      CODE

      has_one :"#{name}_attachment", -> { where(name: name) }, class_name: "ActiveStorage::Attachment", as: :record, inverse_of: :record, dependent: false
      has_one :"#{name}_blob", through: :"#{name}_attachment", class_name: "ActiveStorage::Blob", source: :blob
    end
  end

  def upload(file)
    blob = ActiveStorage::Blob.new
    blob.filename     = file[:filename]
    blob.content_type = file[:content_type]
    blob.service = service

    blob.upload file[:io]
    blob.save
    blob
  end

  def get_url(file)
    key = file[:key]
    filename = ActiveStorage::Filename.wrap(file[:filename])
    content_type = file[:content_type]

    service.url key, expires_in: service.url_expires_in, filename: filename, content_type: content_type, disposition: :inline
  end

  def download
  end
end
