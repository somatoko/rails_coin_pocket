module CryptosHelper

  def coin_title(symbol, name)
    if symbol != name
      "#{symbol} (#{name})"
    else
      symbol
    end
  end

  def calculate_profit(price, price_buy, amount)
    (price * amount) - (price_buy * amount)
  end

  def portfolio_profit(portfolio_list)
    portfolio_list.reduce(0) do |total, u|
      total + (u[:price].to_d * u[:amount_owned]) - (u[:cost_per] * u[:amount_owned])
    end
  end
end
