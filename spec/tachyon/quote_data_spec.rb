require "spec_helper"

RSpec.describe Tachyon do
  before do
    class User < ActiveRecord::Base
    end
  end

  describe ".dump_record" do

    let(:data) { { id: 2, name: "Mr. Borat", age: nil, smoker: 1, created_at: "2016-06-30 03:32:49", updated_at: "2016-06-30 03:32:49" } }

    it "calls quote_value for each value" do
      allow(Tachyon).to receive(:quote_value)

      Tachyon.quote_data(data)

      expect(Tachyon).to have_received(:quote_value).with(data[:id])
      expect(Tachyon).to have_received(:quote_value).with(data[:name])
      expect(Tachyon).to have_received(:quote_value).with(data[:age])
      expect(Tachyon).to have_received(:quote_value).with(data[:smoker])
      expect(Tachyon).to have_received(:quote_value).with(data[:created_at]).twice
    end
  end

  describe ".quote_value" do
    it "quotes strings" do
      quote = Tachyon.quote_value("abc 123")
      expect(quote).to eq("'abc 123'")
    end

    it "quotes strings containing single quotes" do
      quote = Tachyon.quote_value("abc '123")
      expect(quote).to eq("'abc ''123'")
    end

    it "quotes nils" do
      quote = Tachyon.quote_value(nil)
      expect(quote).to eq("NULL")
    end

    it "leaves other data types untouched" do
      [1, 2.0].each do |data|
        quote = Tachyon.quote_value(data)
        expect(quote).to eq(data)
      end
    end
  end

end