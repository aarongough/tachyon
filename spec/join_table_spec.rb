require "spec_helper"

RSpec.describe Tachyon do
  before do
    class UserArticle < ActiveRecord::Base
    end
  end

  it "should omit timestamps when the model does not have them" do
    expect {
      Tachyon.insert(UserArticle, { user_id: 1, article_id: 2 })  
    }.not_to raise_error
  end

end
