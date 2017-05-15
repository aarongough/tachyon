require "spec_helper"

RSpec.describe Tachyon do
  before do
    class User < ActiveRecord::Base
    end
  end

  describe ".insert_records" do
    before do
      User.delete_all
    end

    let(:data) { [
      { id: 1, name: "Mr. Aaron", age: 23, created_at: 1.days.ago, updated_at: 1.days.ago },
      { id: 2, name: "Mr. Borat", age: 24, created_at: 1.days.ago, updated_at: 1.days.ago },
      { id: 3, name: "Mr. Crank", age: 25, created_at: 1.days.ago, updated_at: 1.days.ago },
      { id: 4, name: "Mr. Delta", age: 26, created_at: 1.days.ago, updated_at: 1.days.ago }
    ] }

    it "inserts multiple records" do
      Tachyon.insert(User, data)
      expect(User.count).to eq(4)
    end

    it "preserves the data in each record" do
      Tachyon.insert(User, data)

      data.each do |record|
        user = User.find(record[:id])
        expect(user.name).to eq(record[:name])
        expect(user.age).to eq(record[:age])
        expect(user.created_at).to eq(record[:created_at].utc)
        expect(user.updated_at).to eq(record[:updated_at].utc)
      end
    end
  end
end