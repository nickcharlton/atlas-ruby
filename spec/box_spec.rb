require File.expand_path 'spec_helper.rb', __dir__

describe Atlas::Box do
  before do
    VCR.insert_cassette name

    Atlas.configure do |config|
      config.access_token = 'test-token'
    end
  end

  after do
    VCR.eject_cassette
  end

  it 'can fetch a box' do
    box = Atlas::Box.find('atlas-ruby/example')

    box.wont_be_nil
    box.name.must_equal 'example'
  end

  it 'can build a box from a json response' do
    hash = { 'name' => 'example', 'tag' => 'atlas-ruby/example',
             'short_description' => '', 'description_html' => '',
             'description_markdown' => '', 'username' => 'atlas-ruby',
             'private' => '', 'created_at' => '', 'updated_at' => '' }
    box = Atlas::Box.new('', hash)

    box.wont_be_nil
    box.name.must_equal 'example'
    box.username.must_equal 'atlas-ruby'
  end
end
