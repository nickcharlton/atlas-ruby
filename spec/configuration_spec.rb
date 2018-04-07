require 'spec_helper'

describe Atlas::Configuration do
  let(:config) { Atlas::Configuration.new(token: "abc") }

  it "has a full set of configured values" do
    expect(config.token).to eq "abc"
  end

  it "has a string representation" do
    expect(config.to_s).to be_a String
    # looks for a pattern that looks like:
    #   #<Core::Configuration:70239258795920 stripe_token=a>
    #   #<Core::Configuration:70239258795920>
    expect(config.to_s).to match(/#<[a-zA-Z]*::[a-zA-Z]*:[0-9]*\
(?=>?|\s[a-z_=]*\s?[a-z_=]*>)/)
  end

  it "has a hash representation" do
    expect(config.to_h).to be_a Hash
    expect(config.to_h[:token]).to eq "abc"
  end

  describe "deprecated options" do
    it "shows a warning when initialized" do
      warning_output = "WARNING: Setting the `:access_token` option " \
                       "is deprecated, use `:token` instead\n"

      expect do
        described_class.new(access_token: "abc")
      end.to output(warning_output).to_stderr
    end

    it "shows a warning when assigned" do
      warning_output = "WARNING: Setting the `:access_token` option " \
                       "is deprecated, use `:token` instead\n"

      config = described_class.new

      expect do
        config.access_token = "abc"
      end.to output(warning_output).to_stderr
    end
    it "assigns to the closest alternative" do
      allow($stderr).to receive(:write) # supress stderr

      config = described_class.new(access_token: "abc")

      expect(config.token).to eq("abc")
    end
  end
end
