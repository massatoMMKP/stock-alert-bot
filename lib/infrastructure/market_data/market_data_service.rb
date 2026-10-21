class MarketDataService
  def initialize(provider:)
    @provider = provider
  end

  def price_for(ticker)
    @provider.price_for(ticker)
  end
end