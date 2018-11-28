module PublicS3
  extend ActiveSupport::Concern

  included do
    def service
      @service ||= Publishers::Service::PrivateS3Service.new
    end


    def self.has_public_s3(name, dependent: :purge_later)
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}
          @active_storage_attached_#{name} ||= ActiveStorage::Attached::One.new("#{name}", self, dependent: #{dependent == :purge_later ? ":purge_later" : "false"})
        end

        def #{name}=(attachable)
          #{name}.attach(attachable)
        end

        def upload_public_#{name}(file)
          blob = ActiveStorage::Blob.new.tap do |blob|
            blob.filename     = file[:filename]
            blob.content_type = file[:content_type]
            blob.service = service

            blob.upload file[:io]
          end
          blob.save

          transaction do
            attachment = ActiveStorage::Attachment.new(record: self, name: #{name}, blob: blob)
            self.public_send("#{name}_attachment=", attachment)
          end
        end
      CODE

      has_one :"#{name}_attachment", -> { where(name: name) }, class_name: "ActiveStorage::Attachment", as: :record, inverse_of: :record, dependent: false
      has_one :"#{name}_blob", through: :"#{name}_attachment", class_name: "ActiveStorage::Blob", source: :blob
    end
  end
end
