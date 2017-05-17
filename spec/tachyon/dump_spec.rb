require "spec_helper"

RSpec.describe Tachyon do
  before do
    class User < ActiveRecord::Base
    end
  end

  describe ".dump" do
    before do
      User.delete_all
    end

    let(:data) { { id: 2, name: "Mr. Borat", age: nil, smoker: 1, created_at: "2016-06-30 03:32:49", updated_at: "2016-06-30 03:32:49" } }
    let(:user) { User.create(data) }

    it "should dump the attributes for the record" do
      dump = Tachyon.dump(user)
      expect(dump).to eq(data)
    end

    it "calls dump_attribute for each attribute" do
      allow(Tachyon).to receive(:dump_attribute)

      Tachyon.dump(user)

      expect(Tachyon).to have_received(:dump_attribute).with(user.id)
      expect(Tachyon).to have_received(:dump_attribute).with(user.name)
      expect(Tachyon).to have_received(:dump_attribute).with(user.age)
      expect(Tachyon).to have_received(:dump_attribute).with(user.smoker)
      expect(Tachyon).to have_received(:dump_attribute).with(user.created_at).twice
    end



    it "should produce a format that works with .insert" do
      expect {
        data = Tachyon.dump(user)
        data[:id] = 55
        Tachyon.insert(User, data)
      }.not_to raise_error
    end
  end

  describe ".dump_attribute" do
    it "dumps integers as Integer" do
      dump = Tachyon.dump_attribute(1)
      expect(dump).to be_a Integer
      expect(dump).to eq(1)
    end

    it "dumps strings as String" do
      dump = Tachyon.dump_attribute("foo")
      expect(dump).to be_a String
      expect(dump).to eq("foo")
    end

    it "dumps TrueClass as Integer one" do
      dump = Tachyon.dump_attribute(true)
      expect(dump).to be_a Integer
      expect(dump).to eq(1)
    end

    it "dumps FalseClass as Integer zero" do
      dump = Tachyon.dump_attribute(false)
      expect(dump).to be_a Integer
      expect(dump).to eq(0)
    end

    it "dumps timestamps as String" do
      dump = Tachyon.dump_attribute(Time.new(2016,6,30,3,32,49, "+00:00"))
      expect(dump).to be_a String
      expect(dump).to eq("2016-06-30 03:32:49")
    end

    it "dumps dates as String" do
      dump = Tachyon.dump_attribute(Date.new(1990,7,15))
      expect(dump).to be_a String
      expect(dump).to eq("1990-07-15")
    end

    it "dumps nils as NilClass" do
      dump = Tachyon.dump_attribute(nil)
      expect(nil).to be_a NilClass
      expect(nil).to eq(nil)
    end
  end

end