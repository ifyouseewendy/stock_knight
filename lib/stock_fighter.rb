require 'httparty'
require 'active_support/core_ext/hash/indifferent_access'
require 'json'

require "stock_fighter/version"
require "stock_fighter/client"
require "stock_fighter/game_master"

begin
  require "pry"
  require 'dotenv'
  Dotenv.load if defined? Dotenv
rescue LoadError
end
