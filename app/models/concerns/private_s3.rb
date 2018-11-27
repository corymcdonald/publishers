module PrivateS3
  include ActiveSupport::Concern

  def service
    @service ||= Publishers::Service::PrivateS3Service.new
  end

  def upload(file)

    blob = ActiveStorage::Blob.new
    blob.filename     = file[:filename]
    blob.content_type = file[:content_type]
    blob.service = service

    blob.upload file[:io]
  end

  def download
  end
end
