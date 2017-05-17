# Tachyon

Tachyon is a simple library designed to insert rows into any DB managed by ActiveRecord as fast as possible. Tachyon does not do validations, and only does minimal typescasting. Tachyon simply gets records into the DB as fast as possible. This is very useful in the case when you need to bulk-insert data for some reason, but it really shouldn't be used to replace your normal ActiveRecord DB operations.

## How fast is it?

Tachyon is roughly as fast as executing raw SQL via `ActiveRecord::Base.connection`:

```
Benchmark Results (Inserting 10,000 rows):
------------------------------------------------
User.create(Hash)                 : 8.10 seconds
Raw SQL (w/ string interpolation) : 1.01 seconds
Tachyon.insert(User, Hash)        : 1.03 seconds
```

## Features

* As fast as generating SQL via string interpolation, but with a much nicer syntax!
* Suppresses duplicate key errors, which makes life easier when doing bulk data imports
* Allows you to dump records from the database in a useful format via `Tachyon.dump_record`
* Compatible with MySQL, PostgreSQL and SQLite3

## Caveats

* Tachyon does not perform validations
* Tachyon only does minimal typecasting

## Typecasting

Tachyon does extremely minimal typecasting. Integers and Floats are passed through as literals, nils are converted to NULLs, pretty much all other types should be supplied as strings where appropriate.

## Usage

Simply supply the model class along with a hash of attributes:

```ruby
Tachyon.insert(Article, id: 13, title: "Brand new article")
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

