require "spec_helper"

RSpec.describe Tachyon do
  before do
    class User < ActiveRecord::Base
    end

    class NotAModel
    end
  end

  it "should have a version" do
    expect(Tachyon::VERSION).not_to be nil
  end

  describe ".insert" do
    it "calls insert_record when given a hash" do
      allow(Tachyon).to receive(:insert_record)
      Tachyon.insert(User, {})

      expect(Tachyon).to have_received(:insert_record)
    end

    it "calls insert_records when given an array" do
      allow(Tachyon).to receive(:insert_records)
      Tachyon.insert(User, [])

      expect(Tachyon).to have_received(:insert_records)
    end

    it "raises an error when given invalid data" do
      expect {
        Tachyon.insert(User, 1)  
      }.to raise_error(ArgumentError)
    end

    it "raises an error when given a class that does not inherit from ActiveRecord" do
      expect {
        Tachyon.insert(NotAModel, {})  
      }.to raise_error(ArgumentError)
    end
  end

  describe ".insert_record" do
    before do
      User.delete_all
    end

    it "inserts a single record" do
      Tachyon.insert(User, { name: "Mr. Borat", age: 82 })
      expect(User.count).to eq(1)
    end

    it "preserves the given data" do
      Tachyon.insert(User, { name: "Mr. Borat", age: 82 })
      expect(User.first.name).to eq("Mr. Borat")
      expect(User.first.age).to eq(82)
    end

    it "adds :created_at when not supplied" do
      Tachyon.insert(User, { name: "Mr. Borat", age: 82 })
      expect(User.first.created_at).to be_a(Time)
    end

    it "adds :updated_at when not supplied" do
      Tachyon.insert(User, { name: "Mr. Borat", age: 82 })
      expect(User.first.updated_at).to be_a(Time)
    end

    it "allows overriding of :created_at" do
      time = 3.days.ago
      Tachyon.insert(User, { name: "Mr. Borat", age: 82, created_at: time })
      expect(User.first.created_at).to eq(time)
    end

    it "allows overriding of :updated_at" do
      time = 3.days.ago
      Tachyon.insert(User, { name: "Mr. Borat", age: 82, updated_at: time })
      expect(User.first.updated_at).to eq(time)
    end

    it "allows overriding of :id" do
      Tachyon.insert(User, { id: 82, name: "Mr. Borat", age: 82 })
      expect(User.find(82)).not_to be nil
    end
  end

  describe ".insert_records" do
    before do
      User.delete_all

      Tachyon.insert(User, [
        { name: "Mr. Aaron", age: 23 },
        { name: "Mr. Borat", age: 24 },
        { name: "Mr. Crank", age: 25 },
        { name: "Mr. Delta", age: 26 }
      ])
    end

    it "inserts multiple records" do
      expect(User.count).to eq(4)
    end
  end
end
