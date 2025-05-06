# frozen_string_literal: true

# Wrapping all API calls in a single module.
module Coinmarketcap
  DOMAIN_PRO = 'https://pro-api.coinmarketcap.com'
  KEY_PRO = '********-****-****-****-************'
  DOMAIN_TEST = 'https://sandbox-api.coinmarketcap.com'
  KEY_TEST = 'b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c'
  ENDPOINT = 'v1/cryptocurrency/listings/latest'

  class CoinInfo
    def self.cached_list
      JSON.parse(File.read('response.txt'))['data']
    end

    # Filter the original list by coins in the argument list.
    def self.obtain_coin_info(coins)
      given_symbols = coins
        .map { |c| {c[:symbol].upcase => c[:amount_owned]} } 
        .reduce({}) do |result, u|
          result.merge(u)
        end
      puts given_symbols
      allowed_keys = %w[name symbol quote]
      info_hash = JSON.parse(File.read('response.txt'))['data']
        .filter do |entry|
          given_symbols.keys.include? entry['symbol']
        end
        .map do |entry|
          entry.slice!(*allowed_keys)
          entry['amount_owned'] = given_symbols[entry['symbol']]
          entry
        end
        .reduce({}) do |result, u|
          result.merge({u['symbol'] => u})
        end

      # Now enrich each DB entry with data obtained from API.
      coins
        .map do |c|
          {
            id: c[:id],
            symbol: c[:symbol].upcase,
            name: info_hash[c[:symbol].upcase]['name'],
            amount_owned: c[:amount_owned],
            cost_per: c[:cost_per],
          }
            .merge(info_hash[c[:symbol].upcase]['quote']['USD'])
            .transform_keys(&:to_sym)
        end
    end

    def obtain_response
      require 'net/http'
      require 'json'

      headers = {
        Accept: 'application/json',
        'X-CMC_PRO_API_KEY' => KEY_TEST
      }

      uri = URI("#{DOMAIN_TEST}/#{ENDPOINT}")
      response = Net::HTTP.get(uri, headers)
      File.write('response.txt', response)
    end
  end
end
