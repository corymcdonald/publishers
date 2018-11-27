class DummyTest < ApplicationRecord
  include PrivateS3
  has_private_s3 :invoice
end
