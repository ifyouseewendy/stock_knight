# StockFighter

Ruby API client for [StockFighter](www.stockfighter.io).

## Installation

```sh
$ gem install stock_fighter
```

## API

Initialization

```ruby
client = StockFighter::Client.new do |config|
  config.apikey   = ENV['apikey']
  config.account  = ENV['account']
  config.venue    = ENV['venue']
end
stock = 'FOOBAR'
```

Check A Venue Is Up

> https://starfighter.readme.io/docs/venue-healthchecke

```ruby
client.check_venue_status
```

Stocks on a Venue

> https://starfighter.readme.io/docs/list-stocks-on-venue

```ruby
client.stocks
```

Status For All Orders

> https://starfighter.readme.io/docs/status-for-all-orders

```ruby
client.orders
```

Status For All Orders In A Stock

> https://starfighter.readme.io/docs/status-for-all-orders-in-a-stock

```ruby
client.orders_of(stock)
```

Status For An Existing Order

> https://starfighter.readme.io/docs/status-for-an-existing-order

```ruby
client.query stock, order: '123'
```

A New Order For A Stock

> https://starfighter.readme.io/docs/place-new-order

```ruby
client.buy  stock, price: 100, qty: 10, type: :limit
client.buy  stock, price: 200, qty: 10, type: :market
client.sell stock, price: 300, qty: 10, type: :fill_or_kill
client.sell stock, price: 400, qty: 10, type: :immediate_or_cancel
```

Cancel An Order

> https://starfighter.readme.io/docs/cancel-an-order

```ruby
client.cancel stock, order: '123'
```

### Stock

The Orderbook For A Stock

> https://starfighter.readme.io/docs/get-orderbook-for-stock

```ruby
client.orderbook_of('FOOBAR')
```

A Quote For A Stock

> https://starfighter.readme.io/docs/a-quote-for-a-stock

```ruby
client.quote_of(stock)
```

### API status

> https://starfighter.readme.io/docs/heartbeat

```ruby
account.check_api_status
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

