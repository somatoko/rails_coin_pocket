# frozen_string_literal: true

require './lib/coinmarketcap'

# Main controller of the website.
class HomeController < ApplicationController
  def index
    @coins = Coinmarketcap::CoinInfo.cached_list
    @my_coins = %w[BTC XRP ADA XLM STEEM]
  end

  def about; end

  def lookup
    if params[:sym].nil? || params[:sym].empty?
      @symbol = 'Hey, you forget to enter a currency'
      return
    end

    @symbol = params[:sym].upcase

    Coinmarketcap::CoinInfo.cached_list.each do |coin|
      @info = coin if coin['symbol'] == @symbol
    end
  end
end
