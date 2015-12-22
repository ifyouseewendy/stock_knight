require "stock_fighter/version"
require "stock_fighter/client"

begin
  require "pry"
  require 'dotenv'
  Dotenv.load if defined? Dotenv
rescue LoadError
end
