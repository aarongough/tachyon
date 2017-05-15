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
    context "when given a hash" do
      it "calls insert_record" do
        allow(Tachyon).to receive(:insert_record)
        Tachyon.insert(User, {})

        expect(Tachyon).to have_received(:insert_record)
      end
    end

    context "when given an array" do
      it "calls insert_records" do
        allow(Tachyon).to receive(:insert_records)
        Tachyon.insert(User, [])

        expect(Tachyon).to have_received(:insert_records)
      end
    end

    context "when given invalid data" do
      it "raises an error" do
        expect {
          Tachyon.insert(User, 1)  
        }.to raise_error(ArgumentError)
      end
    end

    context "when given a class that does not inherit from ActiveRecord" do
      it "raises an error" do
        expect {
          Tachyon.insert(NotAModel, {})  
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".insert_record"

  describe ".insert_records"
end
