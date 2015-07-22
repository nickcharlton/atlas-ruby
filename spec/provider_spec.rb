require 'spec_helper'

describe Atlas::BoxProvider do
  before do
    Atlas.configure do |config|
      config.access_token = 'test-token'
    end
  end

  it 'can fetch a provider' do
    VCR.use_cassette('can_fetch_provider') do
      provider = Atlas::BoxProvider.find(
        'atlas-ruby/example/1.0.0/vmware_desktop')

      expect(provider).not_to be_nil
      expect(provider.name).to eq 'vmware_desktop'
    end
  end

  it 'can build a provider from a json response' do
    hash = { 'name' => 'vmware', 'hosted' => '', 'hosted_token' => '',
             'original_url' => '', 'download_url' => '', 'created_at' => '',
             'updated_at' => '' }
    user = Atlas::BoxProvider.new('', hash)

    expect(user).not_to be_nil
    expect(user.name).to eq 'vmware'
  end
end
