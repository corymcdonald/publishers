require "test_helper"
require 'active_storage/service/s3_service'

class DummyTest
  include PrivateS3
end

class PrivateS3Test < ActiveSupport::TestCase
  setup do
    @dummy = DummyTest.new
  end

  test 'testing'  do
    image_path = Rails.root.join("app/assets/images/verified-icon.png")

    result = @dummy.upload(
      io: open(image_path),
      filename: "dummy.jpg",
      content_type: "image/jpg"
    )

    assert result
  end

end
