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
             'original_url' => '', 'download_url' => '', 'created_at' => nil,
             'updated_at' => nil }
    user = Atlas::BoxProvider.new('', hash)

    expect(user).not_to be_nil
    expect(user.name).to eq 'vmware'
  end

  it 'can create a provider' do
    VCR.use_cassette('can_create_provider') do
      allow(Atlas.client).to receive(:post).and_call_original

      provider = Atlas::BoxProvider.create('atlas-ruby/example/1.0.0',
                                           name: 'virtualbox')

      expect(provider).to be_a Atlas::BoxProvider
      expect(provider.name).to eq 'virtualbox'
      expect(Atlas.client).to have_received(:post)
    end
  end

  it 'can create a self-hosted provider' do
    VCR.use_cassette('can_create_self_hosted_provider') do
      allow(Atlas.client).to receive(:post).and_call_original

      url = 'http://boxes.nickcharlton.net.s3.amazonaws.com/'\
            'trusty64-chef-vmware.box'
      provider = Atlas::BoxProvider.create('atlas-ruby/example/1.0.0',
                                           name: 'vmware',
                                           url: url)

      expect(provider).to be_a Atlas::BoxProvider
      expect(provider.name).to eq 'vmware'
      expect(provider.original_url).to eq url
      expect(Atlas.client).to have_received(:post)
    end
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

  it "can upload a file" do
    VCR.use_cassette("can_upload_file") do
      allow(Excon).to receive(:put)

      file = File.open("spec/support/empty_upload_file")
      provider = Atlas::BoxProvider.find("atlas-ruby/example/1.0.0/parallels")

      provider.upload(file)

      expect(Excon).to have_received(:put)
    end
  end

  it 'can delete a provider' do
    VCR.use_cassette('can_delete_provider') do
      allow(Atlas.client).to receive(:delete).and_call_original

      provider = Atlas::BoxProvider.find('atlas-ruby/example/1.0.0/virtualbox')

      response = provider.delete

      expect(response).to be_a Hash
      expect(Atlas.client).to have_received(:delete)
    end
  end
end
