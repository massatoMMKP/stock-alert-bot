module MarketDataProvider
  def price_for(ticker)
    raise NotImplementedError, "Providers must implement #price_for"
  end
end