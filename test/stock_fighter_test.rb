require 'test_helper'

class StockFighterTest < Minitest::Test
  attr_reader :venue, :account, :stock

  def setup
    @venue   = StockFighter::Venue.new('TESTEX')
    @account = StockFighter::Account.new(venue, 'EXB123456', ENV['apikey'])
    @stock   = StockFighter::Stock.new(venue, 'FOOBAR')
  end

  def test_that_it_has_a_version_number
    refute_nil ::StockFighter::VERSION
  end

  def test_api_status
    resp = StockFighter::API.status

    assert resp.has_key?(:ok)
    resp[:ok] ? assert_empty(resp[:error]) : refute_empty(resp[:error])
  end

  def test_venue_status
    resp = venue.status

    assert resp.has_key?(:ok)
    assert_equal "TESTEX", resp[:venue] if resp[:ok]
  end

  def test_stocks_on_a_venue
    resp = venue.stocks

    assert resp.has_key?(:ok)

    if resp[:ok]
      stocks = resp[:symbols]
      assert stocks[0].has_key?(:symbol) if stocks.count > 0
    else
      assert resp.has_key?(:error)
    end
  end

  def test_status_for_all_orders
    resp = account.orders

    assert resp.has_key?(:ok)

    if resp[:ok]
      orders = resp[:orders]
      if orders.count > 0
        assert orders[0].has_key?(:symbol)
        assert_equal 'TESTEX', orders[0][:venue]
      end
    else
      assert resp.has_key?(:error)
    end
  end

  def test_status_for_all_orders_in_a_stock
    resp = account.orders_of(stock)

    assert resp.has_key?(:ok)

    if resp[:ok]
      orders = resp[:orders]
      if orders.count > 0
        assert orders[0].has_key?(:symbol)
        assert_equal 'TESTEX', orders[0][:venue]
      end
    else
      assert resp.has_key?(:error)
    end
  end

  def test_status_for_an_existing_order
    resp = account.orders_of(stock)
    id = resp[:orders][0][:id] if resp[:ok] && resp[:orders].count > 0

    resp = account.query stock, order: id

    assert resp.has_key?(:ok)

    if resp[:ok]
      orders = resp[:orders]
      if orders.count > 0
        assert orders[0].has_key?(:symbol)
        assert orders[0].has_key?(:open)
      end
    else
      assert resp.has_key?(:error)
    end
  end

  def test_a_new_order_for_a_stock
    resp = account.buy stock, price: 100, qty: 10, type: :limit
    assert resp.has_key?(:ok)

    if resp[:ok]
      assert_equal "FOOBAR", resp[:symbol]

      id = resp[:id]
      respp = account.account.query(stock, order: id)
      assert_equal "EXB123456", respp[:account]
    else
      assert resp.has_key?(:error)
    end

    resp = account.sell stock, price: 100000, qty: 10, type: :fill_or_kill
    assert resp.has_key?(:ok)

    if resp[:ok]
      assert_equal "FOOBAR", resp[:symbol]
      refute resp[:open]
    else
      assert resp.has_key?(:error)
    end
  end

  def test_cancel_an_order
    resp = account.sell stock, price: 1_000_000, qty: 1_000_000, type: :limit
    assert resp.has_key?(:ok)

    if resp[:ok]
      assert resp[:open]

      id = resp[:id]
      respp = account.cancel stock, order: id
      assert respp[:ok] && !respp[:open]
    else
      assert resp.has_key?(:error)
    end
  end

  def test_the_orderbook_for_a_stock
    resp = stock.orderbook
    assert resp.has_key?(:ok)

    if resp[:ok]
      assert resp.has_key?(:bids) && resp.has_key?(:asks)
    else
      assert resp.has_key?(:error)
    end
  end

  def test_a_quote_for_a_stock
    resp = stock.quote
    assert resp.has_key?(:ok)

    if resp[:ok]
      assert resp.has_key?(:bid) && resp.has_key?(:ask)
    else
      assert resp.has_key?(:error)
    end
  end
end
