require 'spec_helper'

describe Atlas::BoxVersion do
  before do
    Atlas.configure do |config|
      config.access_token = 'test-token'
    end
  end

  it 'can fetch a version' do
    VCR.use_cassette('can_fetch_version') do
      version = Atlas::BoxVersion.find("atlas-ruby/new-box/1.0.0")

      expect(version).not_to be_nil
      expect(version.version).to eq '1.0.0'
    end
  end

  it 'can build a provider from a json response' do
    hash = { 'version' => '1.0.0', 'status' => '', 'description_html' => '',
             'description_markdown' => '', 'number' => '', 'release_url' => '',
             'revoke_url' => '', 'created_at' => nil, 'updated_at' => nil }
    version = Atlas::BoxVersion.new('', hash)

    expect(version).not_to be_nil
    expect(version.version).to eq '1.0.0'
  end

  it 'can create a version' do
    VCR.use_cassette('can_create_version') do
      allow(Atlas.client).to receive(:post).and_call_original

      version = Atlas::BoxVersion.create("atlas-ruby/new-box", version: "1.0.0")

      expect(version).to be_a Atlas::BoxVersion
      expect(version.version).to eq '1.0.0'
      expect(Atlas.client).to have_received(:post)
    end
  end

  it 'can update an existing version' do
    VCR.use_cassette('can_update_version') do
      allow(Atlas.client).to receive(:put).and_call_original

      version = Atlas::BoxVersion.find("atlas-ruby/new-box/1.0.0")
      original = version.description

      version.description = 'This is a description'
      version.save

      expect(version.description).not_to eq original
      expect(Atlas.client).to have_received(:put)
    end
  end

  it 'can create a provider inside a version' do
    VCR.use_cassette('can_create_provider_inside_version') do
      version = Atlas::BoxVersion.find("atlas-ruby/new-box/1.1.0")

      provider = version.create_provider(name: 'virtualbox')

      expect(provider).to be_a Atlas::BoxProvider
      expect(provider.name).to eq 'virtualbox'
    end
  end

  it 'can delete a version' do
    VCR.use_cassette('can_delete_version') do
      allow(Atlas.client).to receive(:delete).and_call_original

      version = Atlas::BoxVersion.find("atlas-ruby/new-box/1.0.0")

      response = version.delete

      expect(response).to be_a Hash
      expect(Atlas.client).to have_received(:delete)
    end
  end

  it 'can release a version' do
    VCR.use_cassette('can_release_version') do
      allow(Atlas.client).to receive(:put).and_call_original

      version = Atlas::BoxVersion.find("atlas-ruby/new-box/1.0.0")
      version.release

      expect(version.status).to eq 'active'
      expect(Atlas.client).to have_received(:put)
    end
  end

  it 'can revoke a version' do
    VCR.use_cassette('can_revoke_version') do
      allow(Atlas.client).to receive(:put).and_call_original

      version = Atlas::BoxVersion.find('atlas-ruby/example/1.0.0')
      version.revoke

      expect(version.status).to eq 'revoked'
      expect(Atlas.client).to have_received(:put)
    end
  end
end
