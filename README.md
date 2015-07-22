# atlas

Atlas is a Ruby client for [Hashicorp][]'s [Atlas][].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'atlas'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install atlas

## Usage

`atlas` uses an approach similar ActiveRecord:

```ruby
# first, login with the token from Atlas
Atlas.login('token')

# then you can load in users (creating, updating, etc isn't supported by Atlas)
user = Atlas::User.find('nickcharlton')
#=> <Atlas::User username=nickcharlton...>

# or access boxes, their versions and providers
box = Atlas::Box.find('nickcharlton/example-box')
#=> <Atlas::Box name=example-box'...>

# or create a new version
version = box.create(version: '1.0.0', description: 'A new box version.')
```

It aims to support most of the functionality listed in the [Atlas API
Documentation][].

## Contributing

1. Fork it ( https://github.com/nickcharlton/atlas-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Author

Copyright (c) 2015 Nick Charlton <nick@nickcharlton.net>

[Hasicorp]: https://www.hashicorp.com
[Atlas]: https://atlas.hashicorp.com
[Atlas API Documentation]: https://atlas.hashicorp.com/docs
