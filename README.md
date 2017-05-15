# Tachyon

Tachyon is a simple library designed to insert rows into any DB managed by ActiveRecord as fast as possible. Tachyon does not do validations. Tachyon does not throw errors on duplicate keys. Tachyon simply gets records into the DB as fast as possible. This is very useful in the case when you need to bulk-insert data for some reason, but it really shouldn't be used to replace your normal ActiveRecord DB operations.

Tachyon is roughly as fast as executing raw SQL statements, but with a much more readable syntax. Tachyon uses Arel to geneate the SQL statements and to manage type-casting, this helps to avoid the fragility that can come with manually generating SQL.

## How fast is it?

The goal is to be roughly as fast as executing raw SQL via `ActiveRecord::Base.connection`. Tachyon still falls a little short of this mark, but future optimizations will close the gap.

```
Benchmark Results (inserting 5,000 rows):
-------------------------------------------
User.create()               : 4.461711 secs
Raw SQL                     : 0.597918 secs
Tachyon.insert(User, Hash)  : 1.127233 secs
Tachyon.insert(User, Array) : 1.078880 secs
```

## Usage

To insert a single row, simply supply the model class along with a hash of attributes:

```ruby
Tachyon.insert(Article, id: 13, title: "Brand new article")
```

To do a bulk insert, supply the model class and an array of attribute hashes. Tachyon will wrap multiple inserts in a transaction for an extra speed boost:

```ruby
Tachyon.insert(Comment, [
  {id: 1, article_id: 34, title: "Super comment"},
  {id: 2, article_id: 12, title: "Another one"},
  {id: 3, article_id: 90, title: "Comment duex"},
])
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tachyon'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tachyon



## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

