# Tachyon



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tachyon'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tachyon

## Usage

```ruby
Tachyon.insert(Article, id: 13, title: "Brand new article")

Tachyon.insert(Comment, [
  {id: 1, article_id: 34, title: "Super comment"},
  {id: 2, article_id: 12, title: "Another one"},
  {id: 3, article_id: 90, title: "Comment duex"},
])
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

