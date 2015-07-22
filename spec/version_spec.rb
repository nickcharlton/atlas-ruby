require 'spec_helper'

describe Atlas::BoxVersion do
  before do
    Atlas.configure do |config|
      config.access_token = 'test-token'
    end
  end

  it 'can fetch a version' do
    VCR.use_cassette('can_fetch_version') do
      version = Atlas::BoxVersion.find('atlas-ruby/example/1.0.0')

      expect(version).not_to be_nil
      expect(version.version).to eq '1.0.0'
    end
  end

  it 'can build a provider from a json response' do
    hash = { 'version' => '1.0.0', 'status' => '', 'description_html' => '',
             'description_markdown' => '', 'number' => '', 'release_url' => '',
             'revoke_url' => '', 'created_at' => '', 'updated_at' => '' }
    version = Atlas::BoxVersion.new('', hash)

    expect(version).not_to be_nil
    expect(version.version).to eq '1.0.0'
  end
end
