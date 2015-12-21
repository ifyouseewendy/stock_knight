# StockFighter

Ruby API client for [StockFighter](www.stockfighter.io).

## Installation

```sh
$ gem install stock_fighter
```

## API

Initialization

```ruby
venue   = StockFighter::Venue.new(ENV['venue'])
account = StockFighter::Account.new(venue, ENV['account'], ENV['apikey'])
stock   = StockFighter::Stock.new(venue, ENV['stock'])
```

### Venue

Check A Venue Is Up

> https://starfighter.readme.io/docs/venue-healthchecke

```ruby
venue.status
```

Stocks on a Venue

> https://starfighter.readme.io/docs/list-stocks-on-venue

```ruby
venue.stocks
```

### Account

Status For All Orders

> https://starfighter.readme.io/docs/status-for-all-orders

```ruby
account.orders
```

Status For All Orders In A Stock

> https://starfighter.readme.io/docs/status-for-all-orders-in-a-stock

```ruby
account.orders_of(stock)
```

Status For An Existing Order

> https://starfighter.readme.io/docs/status-for-an-existing-order

```ruby
stock.query stock, order: '123'
```

A New Order For A Stock

> https://starfighter.readme.io/docs/place-new-order

```ruby
account.buy  stock, price: 100, qty: 10, type: :limit
account.buy  stock, price: 200, qty: 10, type: :market
account.sell stock, price: 300, qty: 10, type: :fill_or_kill
account.sell stock, price: 400, qty: 10, type: :immediate_or_cancel
```

Cancel An Order

> https://starfighter.readme.io/docs/cancel-an-order

```ruby
account.cancel stock, order: '123'
```

### Stock

The Orderbook For A Stock

> https://starfighter.readme.io/docs/get-orderbook-for-stock

```ruby
stock.orderbook
```

A Quote For A Stock

> https://starfighter.readme.io/docs/a-quote-for-a-stock

```ruby
stock.quote
```

### API status

> https://starfighter.readme.io/docs/heartbeat

```ruby
StockFighter::API.status
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

