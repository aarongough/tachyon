require "spec_helper"

RSpec.describe Tachyon do
  before do
    class User < ActiveRecord::Base
    end
  end

  describe ".insert" do
    before do
      User.delete_all
    end

    let(:data) { { id: 2, name: "Mr. Borat", age: 82, smoker: 1, created_at: "2016-06-30 03:32:49", updated_at: "2016-06-30 03:32:49" } }

    it "inserts a single record" do
      Tachyon.insert(User, data)
      expect(User.count).to eq(1)
    end

    it "allows setting of nils" do
      data[:name] = nil
      Tachyon.insert(User, data)
      expect(User.first.name).to eq(nil)
    end

    it "allows creation of a partial record" do
      expect {
        Tachyon.insert(User, created_at: "2016-06-30 03:32:49", updated_at: "2016-06-30 03:32:49")
      }.not_to raise_error
      expect(User.count).to eq(1)
    end

    it "allows the use of string keys" do
      expect {
        Tachyon.insert(User, "created_at" => "2016-06-30 03:32:49", "updated_at" => "2016-06-30 03:32:49")
      }.not_to raise_error
      expect(User.count).to eq(1)
    end

    it "preserves the given data" do
      Tachyon.insert(User, data)

      attributes = User.first.attributes_before_type_cast
      expect(attributes["id"]).to eq(data[:id])
      expect(attributes["name"]).to eq(data[:name])
      expect(attributes["age"]).to eq(data[:age])
      expect(attributes["created_at"]).to eq(data[:created_at])
      expect(attributes["updated_at"]).to eq(data[:updated_at])
    end

    it "ignores duplicate key errors" do
      expect {
        Tachyon.insert(User, data)
        Tachyon.insert(User, data)
      }.not_to raise_error
    end
  end

end