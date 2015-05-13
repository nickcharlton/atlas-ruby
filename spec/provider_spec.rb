require File.expand_path 'spec_helper.rb', __dir__

describe Atlas::BoxProvider do
  before do
    VCR.insert_cassette name

    Atlas.configure do |config|
      config.access_token = 'test-token'
    end
  end

  after do
    VCR.eject_cassette
  end

  it 'can fetch a provider' do
    provider = Atlas::BoxProvider.load('atlas-ruby', 'example',
                                       '1.0.0', 'vmware_desktop')

    provider.wont_be_nil
    provider.name.must_equal 'vmware_desktop'
  end

  it 'can build a provider from a json response' do
    hash = { 'name' => 'vmware', 'hosted' => '', 'hosted_token' => '',
             'original_url' => '', 'download_url' => '', 'created_at' => '',
             'updated_at' => '' }
    user = Atlas::BoxProvider.from_json(hash)

    user.wont_be_nil
    user.name.must_equal 'vmware'
  end
end
