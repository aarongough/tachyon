require "spec_helper"

RSpec.describe Tachyon do
  before do
    class User < ActiveRecord::Base
    end
  end

  describe "profile" do
    before do
      User.delete_all
    end

    let(:row_count) { 10000 }

    it "profiles Tachyon.insert" do
      $profile = RubyProf.profile do
        row_count.times do |id|
          Tachyon.insert(User, { id: id, name: "Mr. ROBO#{id}", age: id, smoker: 1, created_at: "2016-06-30 03:32:49", updated_at: "2016-06-30 03:32:49" })
        end
      end
    end

  end
end
