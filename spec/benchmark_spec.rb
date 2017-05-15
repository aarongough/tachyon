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

    let(:row_count) { 5000 }

    it "benchmarks insertion via ActiveRecord" do
      $benchmarks["User.create()"] = Benchmark.measure do
       row_count.times do |id|
          User.create(id: id, name: "Mr. ROBO#{id}", age: id)
        end
      end
    end

    it "benchmarks insertion via raw SQL" do
      $benchmarks["Raw SQL"] = Benchmark.measure do
        row_count.times do |id|
          User.connection.execute("
            INSERT INTO users (id, name, age, created_at, updated_at) 
            VALUES (#{id}, 'Mr. ROBO#{id}', #{id}, '#{Time.now.to_s}', '#{Time.now.to_s}')
          ")
        end
      end
    end

    it "benchmarks single insertions via Tachyon" do
      $benchmarks["Tachyon.insert(User, Hash)"] = Benchmark.measure do
        row_count.times do |id|
          Tachyon.insert(User, { id: id, name: "Mr. ROBO#{id}", age: id })
        end
      end
    end

    it "benchmarks bulk inserts via Tachyon" do
      $benchmarks["Tachyon.insert(User, Array)"] = Benchmark.measure do
        rows = []
        row_count.times do |id|
          rows << { id: id, name: "Mr. ROBO#{id}", age: id }
        end

        Tachyon.insert(User, rows)
      end
    end

  end
end
