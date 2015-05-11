require File.expand_path 'spec_helper.rb', __dir__

describe Atlas::Configuration do
  let(:config) { Atlas::Configuration.new access_token: 'abc' }

  it 'has a full set of configured values' do
    config.access_token.must_equal 'abc'
  end

  it 'has a string representation' do
    config.to_s.must_be_kind_of String
    # looks for a pattern that looks like:
    #   #<Core::Configuration:70239258795920 stripe_token=a>
    #   #<Core::Configuration:70239258795920>
    config.to_s.must_match(/#<[a-zA-Z]*::[a-zA-Z]*:[0-9]*\
(?=>?|\s[a-z_=]*\s?[a-z_=]*>)/)
  end

  it 'has a hash representation' do
    config.to_h.must_be_kind_of Hash
    config.to_h[:access_token].must_equal 'abc'
  end
end
