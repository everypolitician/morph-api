# MorphScraper

This is an unofficial wrapper for https://morph.io/ scrapers.

## Disclaimer

Currently a lot of this gem's functionality is implemented by interfacing with the morph.io web interface directly, which means you'll need to provide your (or a bot's) GitHub username and password when using the library.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'morph_scraper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install morph_scraper

## Usage

```ruby
morph = MorphScraper.new(
  scraper: 'tmtmtmtm/malta-parliament',
  github_username: ENV['MORPH_GITHUB_USERNAME'],
  github_password: ENV['MORPH_GITHUB_PASSWORD']
)
morph.run_scraper
```

Note that you need to own or be in the organization for a scraper in order to perform most operations.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/morph_scraper.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

