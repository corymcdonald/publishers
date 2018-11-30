require "test_helper"
require 'active_storage/service/s3_service'

class DummyTest < ActiveRecord::Base
  include PublicS3

  has_one_public_s3 :file
end

class PublicS3Test < ActiveSupport::TestCase
  setup do
  end


  it 'has the correct methods to be defined on the model' do
    assert DummyTest.respond_to?('test_file')
    assert DummyTest.respond_to?('test_file=')
    assert DummyTest.respond_to?('upload_public_test_file')
    assert DummyTest.respond_to?('public_test_file_url')
    assert DummyTest.respond_to?('test_file_purge_later')
    assert DummyTest.respond_to?('test_file_detach')
  end

end
