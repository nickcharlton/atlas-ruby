require 'spec_helper'

describe Atlas::User do
  before do
    Atlas.configure do |config|
      config.access_token = 'test-token'
    end
  end

  it 'can fetch a user' do
    VCR.use_cassette('can_fetch_user') do
      user = Atlas::User.find('atlas-ruby')

      expect(user).not_to be_nil
      expect(user.username).to eq 'atlas-ruby'
      expect(user.boxes).to be_a Array
    end
  end

  it 'can build a user from a json response' do
    hash = { 'username' => 'user', 'avatar_url' => '', 'profile_html' => '',
             'profile_markdown' => '', 'boxes' => [] }
    user = Atlas::User.new('', hash)

    expect(user).not_to be_nil
    expect(user.username).to eq 'user'
    expect(user.boxes).to be_a Array
  end
end
