class CheckStockTarget
  def initialize(market_data:, notifier:)
    @market_data = market_data
    @notifier = notifier
  end

  def call(stock)
    current_price = @market_data.price_for(stock.ticker)

    return unless stock.target_reached?(current_price)

    @notifier.notify(stock, current_price)
  end
end