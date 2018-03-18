require "spec_helper"
require "core_ext/hash_replace_key"

RSpec.describe HashReplaceKey do
  describe "#replace_key" do
    it "replaces a key with a given replacement and returns a new hash" do
      original = { foo: "bar" }

      new_hash = original.replace_key(:foo, :baz)

      expect(new_hash).to include(baz: "bar")
      expect(new_hash).not_to include(foo: "bar")
      expect(original.object_id).not_to eq(new_hash.object_id)
    end
  end

  describe "#replace_key!" do
    it "replaces a key with a given replacement in place" do
      original = { foo: "bar" }

      new_hash = original.replace_key!(:foo, :baz)

      expect(new_hash).to include(baz: "bar")
      expect(new_hash).not_to include(foo: "bar")
      expect(original.object_id).to eq(new_hash.object_id)
    end

    it "does nothing if the original key is missing" do
      original = { foo: "bar" }

      new_hash = original.replace_key(:baz, :boo)

      expect(original).to eq(new_hash)
    end

    it "copies nil values where the key is present" do
      original = { bar: nil }

      new_hash = original.replace_key!(:bar, :another)

      expect(new_hash).to include(another: nil)
    end
  end
end
