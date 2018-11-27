require "test_helper"
require 'active_storage/service/s3_service'

class PrivateS3Test < ActiveSupport::TestCase
  setup do
    @dummy = DummyTest.new
  end

  test 'testing'  do
    image_path = Rails.root.join("app/assets/images/verified-icon.png")

    SiteBanner.new.logo.attach(
      io: open(image_path),
      filename: "logo",
      content_type: "image/jpg"
    )
    binding.pry

    # result = @dummy.invoice
    #   io: open(image_path),
    #   filename: "dummy",
    #   content_type: "image/jpg"
    # )
    # result = @dummy.invoices

    p = @dummy.get_url(
      key: result.key,
      filename: "dummy",
      content_type: "image/jpg"
    )

    # @dummy.service_url(key:'dummy')
    binding.pry
    assert result
  end

end
