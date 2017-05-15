ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.string :name
    t.integer :age

    t.timestamps
  end

  create_table :user_articles, :force => true do |t|
    t.integer :article_id
    t.integer :user_id
  end

end