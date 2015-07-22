require File.expand_path 'spec_helper.rb', __dir__

describe Atlas::User do
  before do
    VCR.insert_cassette name

    Atlas.configure do |config|
      config.access_token = 'test-token'
    end
  end

  after do
    VCR.eject_cassette
  end

  it 'can fetch a user' do
    user = Atlas::User.find('atlas-ruby')

    user.wont_be_nil
    user.username.must_equal 'atlas-ruby'
    user.boxes.must_be_kind_of Array
  end

  it 'can build a user from a json response' do
    hash = { 'username' => 'user', 'avatar_url' => '', 'profile_html' => '',
             'profile_markdown' => '', 'boxes' => [] }
    user = Atlas::User.new('', hash)

    user.wont_be_nil
    user.username.must_equal 'user'
    user.boxes.must_be_kind_of Array
  end
end
