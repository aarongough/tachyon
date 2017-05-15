require "spec_helper"

RSpec.describe Tachyon do
  before do
    class User < ActiveRecord::Base
    end

    class NotAModel
    end
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

end
