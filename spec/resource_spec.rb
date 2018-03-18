require "spec_helper"

describe Atlas::Resource do
  describe ".date_accessor" do
    let(:date) { Time.new(2016, 2, 15, 14, 49, 54) }
    let(:resource) { example_resource.new("tag") }

    it "outputs a date object" do
      resource.created_at = date

      expect(resource.created_at).to eq date
    end

    it "parses a string on assignment" do
      resource.created_at = "2016-02-15T14:49:54Z"

      expect(resource.created_at).to eq date
    end
  end

  def example_resource
    Class.new(Atlas::Resource) do
      date_accessor :created_at
    end
  end
end
