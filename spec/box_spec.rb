require 'spec_helper'

describe Atlas::Box do
  before do
    Atlas.configure do |config|
      config.access_token = 'test-token'
    end
  end

  it 'can fetch a box' do
    VCR.use_cassette('can_fetch_box') do
      box = Atlas::Box.find('atlas-ruby/example')

      expect(box).not_to be_nil
      expect(box.name).to eq 'example'
    end
  end

  it 'can build a box from a json response' do
    hash = { 'name' => 'example', 'tag' => 'atlas-ruby/example',
             'short_description' => '', 'description_html' => '',
             'description_markdown' => '', 'username' => 'atlas-ruby',
             'private' => '', 'created_at' => '', 'updated_at' => '' }
    box = Atlas::Box.new('', hash)

    expect(box).not_to be_nil
    expect(box.name).to eq 'example'
    expect(box.username).to eq 'atlas-ruby'
  end
end
