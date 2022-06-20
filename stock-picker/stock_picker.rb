def stock_picker(stock_prices)
  projected_profit = {}
  stock_prices.each_with_index do |sell_price, sell_day|
    stock_prices.reduce do |profit, buy_price|
      if sell_day > stock_prices.index(buy_price)
        profit = sell_price - buy_price
        projected_profit[profit] = [stock_prices.index(buy_price), sell_day]
      end
    end
  end
  maximum_profit = projected_profit.keys.reduce { |max_profit, profit| max_profit > profit ? max_profit : profit }
  projected_profit[maximum_profit]
end

p stock_picker([17, 3, 6, 9, 15, 8, 6, 1, 10])
