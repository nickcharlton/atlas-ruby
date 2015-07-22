require File.expand_path 'spec_helper.rb', __dir__

describe Atlas::BoxVersion do
  before do
    VCR.insert_cassette name

    Atlas.configure do |config|
      config.access_token = 'test-token'
    end
  end

  after do
    VCR.eject_cassette
  end

  it 'can fetch a version' do
    version = Atlas::BoxVersion.find('atlas-ruby/example/1.0.0')

    version.wont_be_nil
    version.version.must_equal '1.0.0'
  end

  it 'can build a provider from a json response' do
    hash = { 'version' => '1.0.0', 'status' => '', 'description_html' => '',
             'description_markdown' => '', 'number' => '', 'release_url' => '',
             'revoke_url' => '', 'created_at' => '', 'updated_at' => '' }
    version = Atlas::BoxVersion.new('', hash)

    version.wont_be_nil
    version.version.must_equal '1.0.0'
  end
end
