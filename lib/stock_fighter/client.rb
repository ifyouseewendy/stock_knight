module StockFighter
  class Client
    attr_reader :config

    include HTTParty
    base_uri 'https://api.stockfighter.io/ob/api'

    class Parser::Simple < HTTParty::Parser
      def parse
        JSON.parse(body).with_indifferent_access
      end
    end

    parser Parser::Simple

    CONFIG = Struct.new(:apikey, :account, :venue) do
      def validate!
        key = %i(apikey account venue).detect{|k| self.public_send(k).nil? }
        raise ArgumentError, "#{key} should not be blank" unless key.nil?
      end
    end

    TYPES = [:limit, :market, :fill_or_kill, :immediate_or_cancel]

    def initialize
      yield (@config=CONFIG.new)

      config.validate!
    end

    def check_api_status
      self.class.get('/heartbeat', headers)
    end

    private

      def headers
        @_headers ||= { headers: { "X-Stockfighter-Authorization" => config.apikey } }
      end

  end
end
