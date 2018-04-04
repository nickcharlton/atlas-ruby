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
             'private' => '', 'created_at' => nil, 'updated_at' => nil }
    box = Atlas::Box.new('', hash)

    expect(box).not_to be_nil
    expect(box.name).to eq 'example'
    expect(box.username).to eq 'atlas-ruby'
  end

  describe "#create" do
    it "creates a private box by default" do
      VCR.use_cassette("can_create_box") do
        box = Atlas::Box.create(
          name: "new-box",
          username: "atlas-ruby",
          short_description: "A new box",
          description: "A new box",
        )

        expect(box).to be_a(Atlas::Box)
        expect(box).to have_attributes(
          name: "new-box",
          username: "atlas-ruby",
          short_description: "A new box",
          description: "A new box",
          private: true,
        )
      end
    end

    it "adjusts the private call when creating a public box" do
      VCR.use_cassette("can_create_public_box") do
        box = Atlas::Box.create(
          name: "new-public-box",
          username: "atlas-ruby",
          short_description: "A new box",
          description: "A new box",
          private: false,
        )

        expect(box).to be_a(Atlas::Box)
        expect(box).to have_attributes(
          name: "new-public-box",
          username: "atlas-ruby",
          short_description: "A new box",
          description: "A new box",
          private: false,
        )
      end
    end
  end

  it 'can update an existing box' do
    VCR.use_cassette('can_update_box') do
      allow(Atlas.client).to receive(:put).and_call_original

      box = Atlas::Box.find("atlas-ruby/new-box")
      original = box.short_description

      box.short_description = 'A short description of this box.'
      box.save

      expect(box.short_description).not_to eq original
      expect(Atlas.client).to have_received(:put)
    end
  end

  it 'can create a version inside a box' do
    VCR.use_cassette('can_create_version_inside_box') do
      box = Atlas::Box.find("atlas-ruby/new-box")

      version = box.create_version(version: '1.1.0', description: 'New Box')

      expect(version).to be_a Atlas::BoxVersion
      expect(version.version).to eq '1.1.0'
      expect(version.description).to eq 'New Box'
    end
  end

  it 'can delete a box' do
    VCR.use_cassette('can_delete_box') do
      allow(Atlas.client).to receive(:delete).and_call_original

      box = Atlas::Box.find("atlas-ruby/new-box")

      response = box.delete

      expect(response).to be_a Hash
      expect(Atlas.client).to have_received(:delete)
    end
  end
end
