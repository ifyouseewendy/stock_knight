require 'test_helper'

class StockFighterTest < Minitest::Test
  attr_reader :client, :stock

  ACCOUNT = 'EXB123456'
  VENUE   = 'TESTEX'
  STOCK   = 'FOOBAR'

  def setup
    @client = StockFighter::Client.new do |config|
      config.apikey   = ENV['APIKEY']
      config.account  = ACCOUNT
      config.venue    = VENUE
    end
    @stock = STOCK
  end

  def test_that_it_has_a_version_number
    refute_nil ::StockFighter::VERSION
  end

  def test_config_setting
    assert_raises ArgumentError, "apikey should not be blank" do
      StockFighter::Client.new do |config|
        config.apikey   = nil
        config.account  = ACCOUNT
        config.venue    = STOCK
      end
    end
  end

  def test_api_status
    resp = client.check_api_status

    assert resp.has_key?(:ok)
    resp[:ok] ? assert_empty(resp[:error]) : refute_empty(resp[:error])
  end

  def test_venue_status
    resp = client.check_venue_status

    assert resp.has_key?(:ok)
    assert_equal VENUE, resp[:venue] if resp[:ok]
  end

  def test_stocks_on_a_venue
    resp = client.stocks

    assert resp.has_key?(:ok)

    if resp[:ok]
      symbols = resp[:symbols]
      assert symbols[0].has_key?(:symbol) if symbols.count > 0
    else
      assert resp.has_key?(:error)
    end
  end

  def test_status_for_all_orders
    resp = client.orders

    assert resp.has_key?(:ok)

    if resp[:ok]
      orders = resp[:orders]
      if orders.count > 0
        assert        orders[0].has_key?(:symbol)
        assert_equal  VENUE, orders[0][:venue]
      end
    else
      assert resp.has_key?(:error)
    end
  end

  def test_status_for_all_orders_in_a_stock
    resp = client.orders_of(stock)

    assert resp.has_key?(:ok)

    if resp[:ok]
      unless (order=resp[:orders][0]).nil?
        assert_equal stock, order[:symbol]
      end
    else
      assert resp.has_key?(:error)
    end
  end

  def test_status_for_an_existing_order
    resp = client.orders_of(stock)
    id = resp[:orders][0][:id] if resp[:ok] && resp[:orders].count > 0

    resp = client.query stock, order: id

    assert resp.has_key?(:ok)

    if resp[:ok]
      assert_equal  stock, resp[:symbol]
      assert        resp.has_key?(:open)
    else
      assert resp.has_key?(:error)
    end
  end

  def test_a_new_order_for_a_stock
    assert_raises ArgumentError, "type is not valid" do
      client.buy stock, price: 100, qty: 10, type: :custom_type
    end

    resp = client.buy stock, price: 100, qty: 10, type: :limit
    assert resp.has_key?(:ok)

    if resp[:ok]
      assert_equal stock, resp[:symbol]

      id = resp[:id]
      respp = client.query(stock, order: id)
      assert respp[:ok]
    else
      assert resp.has_key?(:error)
    end

    resp = client.sell stock, price: 100000, qty: 10, type: :fill_or_kill
    assert resp.has_key?(:ok)

    if resp[:ok]
      assert_equal stock, resp[:symbol]
      refute resp[:open]
    else
      assert resp.has_key?(:error)
    end
  end

  def test_cancel_an_order
    resp = client.sell stock, price: 1_000_000, qty: 1_000_000, type: :limit
    assert resp.has_key?(:ok)

    if resp[:ok]
      assert resp[:open]

      id = resp[:id]
      respp = client.cancel stock, order: id
      assert respp[:ok] && !respp[:open]
    else
      assert resp.has_key?(:error)
    end
  end

  def test_the_orderbook_for_a_stock
    resp = client.orderbook_of(stock)
    assert resp.has_key?(:ok)

    if resp[:ok]
      assert resp.has_key?(:bids) && resp.has_key?(:asks)
    else
      assert resp.has_key?(:error)
    end
  end

  def test_a_quote_for_a_stock
    resp = client.quote_of(stock)
    assert resp.has_key?(:ok)

    if resp[:ok]
      assert resp.has_key?(:bidSize) && resp.has_key?(:askSize)
    else
      assert resp.has_key?(:error)
    end
  end
end
