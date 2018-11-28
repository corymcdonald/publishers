# Model

class DummyTest < ApplicationRecord
  include PublicS3

  has_public_s3 :invoice
end
