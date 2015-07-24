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

  it 'can update an existing provider' do
    VCR.use_cassette('can_update_provider') do
      allow(Atlas.client).to receive(:put).and_call_original
      allow(Atlas.client).to receive(:post)

      provider = Atlas::BoxProvider.find('atlas-ruby/example/1.0.0/virtualbox')

      provider.name = 'vmware_desktop'
      provider.save

      expect(provider.name).to eq 'vmware_desktop'
      expect(Atlas.client).to have_received(:put)
      expect(Atlas.client).not_to have_received(:post)
    end
  end
end
