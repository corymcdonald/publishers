require "test_helper"
require 'active_storage/service/s3_service'

class PrivateS3Test < ActiveSupport::TestCase
  setup do
    # @dummy = DummyTest.new
  end

  test 'testing'  do
    image_path = Rails.root.join("app/assets/images/verified-icon.png")

    # s = SiteBanner.new(title: 'a', description: 'tr', donation_amounts: [ 1 ], default_donation: 5, publisher: Publisher.first)
    # s.save

    # s.logo.attach(
    #   io: open(image_path),
    #   filename: "logo",
    #   content_type: "image/jpg"
    # )


    DummyTest.destroy_all

    @dummy = DummyTest.new
    @dummy.save

    @dummy.upload_public_invoice(
      {
        io: open(image_path),
        filename: "dummy",
        content_type: "image/jpg"
      }
    )

    @dummy.public_invoice_url

    binding.pry

    # TODO figure out how to get a public thing
    # result = @dummy.invoices

    # p = @dummy.get_url(
    #   key: result.key,
    #   filename: "dummy",
    #   content_type: "image/jpg"
    # )

    # @dummy.service_url(key:'dummy')
    # binding.pry

  end

end
