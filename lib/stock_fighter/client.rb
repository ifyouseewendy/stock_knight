module StockFighter
  class Client
    attr_reader :config

    CONFIG = Struct.new(:apikey, :account, :venue) do
      def validate!
        key = %i(apikey account venue).detect{|k| self.public_send(k).nil? }
        raise ArgumentError, "#{key} should not be blank" unless key.nil?
      end
    end

    def initialize
      yield (@config=CONFIG.new)
      @config.validate!
    end
  end
end
