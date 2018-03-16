require "spec_helper"

describe Atlas::Resource do
  describe "#attributes" do
    it "returns a list of resource attributes" do
      attributes = example_resource.new("tag", name: "example").attributes

      expect(attributes).to include("name")
    end

    it "excludes internal attributes" do
      attributes = example_resource.new("tag", name: "example").attributes

      expect(attributes).not_to include(["tag", "url_builder"])
    end
  end

  describe "#to_hash" do
    it "returns a hash of attributes and their values" do
      hash = example_resource.new("tag", name: "example").to_hash

      expect(hash).to eq(name: "example")
    end
  end

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

  describe ".validate!" do
    it "validates expected fields are not nil" do
      resource = example_resource.new("tag")

      expect do
        resource.validate!
      end.to raise_error(Atlas::Errors::InvalidResourceError)
    end
  end

  def example_resource
    Class.new(Atlas::Resource) do
      def self.name
        "ExampleResource"
      end

      attr_accessor :name, :private
      date_accessor :created_at

      requires :name
    end
  end
end
