# LocomotiveCurrency

Adds a new Liquid Tag "currnecy" and "currency_date" for Locomotive CMS.

## Installation

Add this line to your application's Gemfile:

    gem 'locomotive_currency'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install locomotive_currency

## Usage

{% currency_date 'EURUSD' %}

Returns the date the currency was updated

{% currency 'EURUSD' %}

Returns the exchange rate

## ToDo

Add some tests

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
