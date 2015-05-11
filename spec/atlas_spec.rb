require File.expand_path 'spec_helper.rb', __dir__

describe Atlas do
  it 'has a version number' do
    Atlas::VERSION.wont_be_nil
  end
end
