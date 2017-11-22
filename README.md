# Transposon

From [octokit/octokit.rb](https://github.com/octokit/octokit.rb/#philosophy):

> API wrappers [should reflect the idioms of the language in which they were
written](http://wynnnetherland.com/journal/what-makes-a-good-api-wrapper).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'transposon'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transposon

## Usage

``` ruby
# pass in a filename
client = Transposon::Client.new(filename: filename)

# or pass in a string
client = Transposon::Client.new(schema: contents)
```
