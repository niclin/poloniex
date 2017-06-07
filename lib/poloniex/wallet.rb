module Poloniex
  class Wallet < BasePoloniex
    attr_reader :currency, :balance, :raw, :error
    def initialize(attrs = {})
      @currency = attrs.first
      @balance = attrs.last
      @raw = attrs
    end

    def self.balances
      response = client.post('returnCompleteBalances')
      response.map { |e| new(e)  } if response.present?
    end

    def self.balance_by_currency(currency)
      balances.detect { |e| e.currency == normalize_currency(currency) }
    end

    def self.total_btc
      response = client.post('returnCompleteBalances')

      btc = 0

      response.each do |coin_type|
        btc += coin_type[1]["btcValue"].to_f
      end

      btc
    end
  end
end
