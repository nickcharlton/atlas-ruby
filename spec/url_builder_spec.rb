require 'spec_helper'

describe Atlas::UrlBuilder do
  describe 'when given a full tag' do
    let(:tag) { Atlas::UrlBuilder.new 'nickcharlton/ruby-box/1.0.0/vmware' }

    it 'has a user url' do
      expect(tag.user_url).to eq '/user/nickcharlton'
    end

    it 'has a box url' do
      expect(tag.box_url).to eq '/box/nickcharlton/ruby-box'
    end

    it 'has a box version url' do
      expect(tag.box_version_url).to eq \
        '/box/nickcharlton/ruby-box/version/1.0.0'
    end

    it 'has a box provider url' do
      expect(tag.box_provider_url).to eq \
        '/box/nickcharlton/ruby-box/version/1.0.0/provider/vmware'
    end
  end

  describe 'when given a box tag' do
    let(:tag) { Atlas::UrlBuilder.new 'nickcharlton/ruby-box' }

    it 'has a user url' do
      expect(tag.user_url).to eq '/user/nickcharlton'
    end

    it 'has a box url' do
      expect(tag.box_url).to eq '/box/nickcharlton/ruby-box'
    end

    it 'cannot have a box version url' do
      expect(tag.box_version_url).to be_nil
    end

    it 'cannot have a box provider url' do
      expect(tag.box_provider_url).to be_nil
    end
  end
end
