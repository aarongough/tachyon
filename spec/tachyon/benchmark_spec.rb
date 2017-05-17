require "spec_helper"

RSpec.describe Tachyon do
  before do
    class User < ActiveRecord::Base
    end
  end

  describe "benchmark" do
    before do
      User.delete_all
    end

    let(:row_count) { 10000 }

    it "benchmarks insertion via ActiveRecord" do
      $benchmarks["User.create(Hash)"] = Benchmark.measure do
       row_count.times do |id|
          User.create(id: id, name: "Mr. ROBO#{id}", age: id, smoker: true, created_at: "2016-06-30 03:32:49", updated_at: "2016-06-30 03:32:49")
        end
      end
    end

    it "benchmarks insertion via raw SQL" do
      $benchmarks["Raw SQL (w/ string interpolation)"] = Benchmark.measure do
        row_count.times do |id|
          User.connection.execute("
            INSERT INTO users (id, name, age, created_at, updated_at)
            VALUES (#{id}, 'Mr. ROBO#{id}', #{id}, '#{Time.now.to_s}', '#{Time.now.to_s}')
          ")
        end
      end
    end

    it "benchmarks insertion via Tachyon" do
      $benchmarks["Tachyon.insert(User, Hash)"] = Benchmark.measure do
        row_count.times do |id|
          Tachyon.insert(User, { id: id, name: "Mr. ROBO#{id}", age: id, smoker: 1, created_at: "2016-06-30 03:32:49", updated_at: "2016-06-30 03:32:49" })
        end
      end
    end

  end
end
