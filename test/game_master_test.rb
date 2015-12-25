require 'test_helper'

class GameMasterTest < Minitest::Test
  attr_reader :gm

  def setup
    @gm = StockFighter::GameMaster.new(ENV['APIKEY'], :first_steps)
  end

  def test_start
    resp = nil

    VCR.use_cassette("start") do
      resp = gm.start

      assert resp.has_key?(:ok)
      resp[:ok] ? assert_nil(resp[:error]) : refute_nil(resp[:error])
    end

    VCR.use_cassette("start_then_stop") do
      instance_id = resp[:instanceId]
      gm.stop(instance_id)
    end
  end

  def test_stop
    resp = nil

    VCR.use_cassette("start") do
      resp = gm.start
    end

    VCR.use_cassette("start_then_stop") do
      instance_id = resp[:instanceId]

      resp = gm.stop(instance_id)

      assert resp.has_key?(:ok)
      resp[:ok] ? assert_empty(resp[:error]) : refute_empty(resp[:error])
    end
  end

  def test_active?
    VCR.use_cassette("active_fake_id") do
      refute gm.active?('fake_id')
    end

    resp = nil
    VCR.use_cassette("start") do
      resp = gm.start
    end

    VCR.use_cassette("active_instance_id") do
      instance_id = resp[:instanceId]
      assert gm.active?(instance_id)
    end

    VCR.use_cassette("start_then_stop") do
      gm.stop(instance_id)
    end
  end

  def test_resume
    resp = nil

    VCR.use_cassette("start") do
      resp = gm.start
    end

    instance_id = resp[:instanceId]

    VCR.use_cassette("resume") do
      resp = gm.resume(instance_id)
      assert resp.has_key?(:ok)
      resp[:ok] ? assert_empty(resp[:error]) : refute_empty(resp[:error])
    end

    VCR.use_cassette("start_then_stop") do
      gm.stop(instance_id)
    end
  end

  def test_restart
    resp = nil

    VCR.use_cassette("start") do
      resp = gm.start
    end

    instance_id = resp[:instanceId]
    account     = resp[:account]

    VCR.use_cassette("restart") do
      resp = gm.restart(instance_id)
      assert_equal instance_id, resp[:instanceId]
      refute_equal account, resp[:account]
    end
  end
end
