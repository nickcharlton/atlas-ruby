require File.expand_path 'spec_helper.rb', __dir__

describe Atlas::UrlBuilder do
  describe 'when given a full tag' do
    let(:tag) { Atlas::UrlBuilder.new 'nickcharlton/ruby-box/1.0.0/vmware' }

    it 'has a user url' do
      tag.user_url.must_equal '/user/nickcharlton'
    end

    it 'has a box url' do
      tag.box_url.must_equal '/box/nickcharlton/ruby-box'
    end

    it 'has a box version url' do
      tag.box_version_url.must_equal '/box/nickcharlton/ruby-box/version/1.0.0'
    end

    it 'has a box provider url' do
      tag.box_provider_url.must_equal \
        '/box/nickcharlton/ruby-box/version/1.0.0/provider/vmware'
    end
  end

  describe 'when given a box tag' do
    let(:tag) { Atlas::UrlBuilder.new 'nickcharlton/ruby-box' }

    it 'has a user url' do
      tag.user_url.must_equal '/user/nickcharlton'
    end

    it 'has a box url' do
      tag.box_url.must_equal '/box/nickcharlton/ruby-box'
    end

    it 'cannot have a box version url' do
      tag.box_version_url.must_be_nil
    end

    it 'cannot have a box provider url' do
      tag.box_provider_url.must_be_nil
    end
  end
end
