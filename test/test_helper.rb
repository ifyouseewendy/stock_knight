$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'stock_fighter'

require 'minitest/autorun'

begin
  require 'minitest/focus'
rescue LoadError
end
