require "spec_helper"

RSpec.describe Tachyon do
  before do
    class User < ActiveRecord::Base
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