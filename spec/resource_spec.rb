require "spec_helper"

describe Atlas::Resource do
  context "using the date accessor" do
    let(:date) { DateTime.new(2016, 02, 15, 14, 49, 54) }
    let(:resource) do
      class ExampleResource < Atlas::Resource
        date_accessor :created_at
      end

      ExampleResource.new("tag")
    end

    it "will output a Date object" do
      resource.created_at = date

      expect(resource.created_at).to eq date
    end

    it "will convert a String to a Date" do
      resource.created_at = "2016-02-15T14:49:54Z"

      expect(resource.created_at).to eq date
    end
  end
end
