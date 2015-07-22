require 'spec_helper'

describe Atlas::Configuration do
  let(:config) { Atlas::Configuration.new access_token: 'abc' }

  it 'has a full set of configured values' do
    expect(config.access_token).to eq 'abc'
  end

  it 'has a string representation' do
    expect(config.to_s).to be_a String
    # looks for a pattern that looks like:
    #   #<Core::Configuration:70239258795920 stripe_token=a>
    #   #<Core::Configuration:70239258795920>
    expect(config.to_s).to match(/#<[a-zA-Z]*::[a-zA-Z]*:[0-9]*\
(?=>?|\s[a-z_=]*\s?[a-z_=]*>)/)
  end

  it 'has a hash representation' do
    expect(config.to_h).to be_a Hash
    expect(config.to_h[:access_token]).to eq 'abc'
  end
end
