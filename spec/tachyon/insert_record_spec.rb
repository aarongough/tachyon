require "spec_helper"

RSpec.describe Tachyon do
  before do
    class User < ActiveRecord::Base
    end

    class UserArticle < ActiveRecord::Base
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

    it "omits timestamps when the model does not have them" do
      expect {
        Tachyon.insert(UserArticle, { user_id: 1, article_id: 2 })  
      }.not_to raise_error
    end

    it "ignores duplicate key errors" do
      expect {
        Tachyon.insert(User, { id: 82, name: "Mr. Borat", age: 82 })
        Tachyon.insert(User, { id: 82, name: "Mr. Borat", age: 82 })
      }.not_to raise_error
    end
  end

end