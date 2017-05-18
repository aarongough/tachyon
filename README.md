# Tachyon

Tachyon is a simple library designed to insert rows into any DB managed by ActiveRecord as fast as possible. Tachyon does not do validations, and only does minimal typecasting. Tachyon simply gets records into the DB as fast as possible. This is very useful in the case when you need to bulk-insert data for some reason, but it really shouldn't be used to replace your normal ActiveRecord DB operations.

An ideal use-case for Tachyon (and the reason it was developed) is to dump/insert data from the DB as part of the setup step for large test cases.

## How fast is it?

Tachyon is as fast (or faster) than executing raw SQL via `ActiveRecord::Base.connection`:

```
Benchmark Results (Inserting 10,000 rows):
------------------------------------------------
User.create(Hash)                 : 8.14 seconds
Raw SQL (w/ string interpolation) : 1.17 seconds
Tachyon.insert(User, Hash)        : 1.03 seconds
```

## Features

* As fast (or faster!) than generating SQL via string interpolation, but with a much nicer syntax!
* Suppresses duplicate key errors, which makes life easier when doing bulk data imports
* Allows you to dump records from the database in a useful format via `Tachyon.dump`
* Compatible with MySQL, PostgreSQL and SQLite3

## Caveats

* Tachyon does not perform validations
* Tachyon only does minimal typecasting (ie: inserting a `Time` object does not work, use `Time.to_s(:db)` instead)

## Typecasting

Tachyon does extremely minimal typecasting. Integers and Floats are passed through as literals, nils are converted to NULLs, pretty much all other types should be supplied as strings where appropriate.

## Usage

To insert simply supply the model class along with a hash of attributes:

```ruby
Tachyon.insert(Article, id: 13, title: "Brand new article")
```

And to dump a record simply call `Tachyon.dump`:

```ruby
article = Article.find(13)
Tachyon.dump(article)
=> { id: 13, title: "Brand new article", created_at: "2016-06-30 03:32:49", updated_at: "2016-06-30 03:32:49" }
```

Note that Tachyon is dumping the data in a way that is directly compatible with the DB, the data won't require much in the way of typecasting to insert it back into the DB.

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

