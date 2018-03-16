require "spec_helper"

describe Atlas::Validations do
  describe "#validate!" do
    it "doesn't throw an exception if required attributes exist" do
      example_resource = Class.new(Atlas::Resource) do
        def self.name
          "ExampleResource"
        end

        attr_accessor :name

        requires :name
      end

      resource = example_resource.new("tag", name: "example")

      expect { resource.validate! }.not_to raise_error
    end

    it "throws an exception if required attributes are missing" do
      example_resource = Class.new(Atlas::Resource) do
        def self.name
          "ExampleResource"
        end

        attr_accessor :name, :user

        requires :name, :user
      end

      resource = example_resource.new("tag", name: "atlas-ruby")

      expect do
        resource.validate!
      end.to raise_error(Atlas::Errors::InvalidResourceError)
    end

    it "throws an exception if required attributes are nil" do
      example_resource = Class.new(Atlas::Resource) do
        def self.name
          "ExampleResource"
        end

        attr_accessor :name

        requires :name
      end

      resource = example_resource.new("tag", name: nil)

      expect do
        resource.validate!
      end.to raise_error(Atlas::Errors::InvalidResourceError)
    end
  end
end
