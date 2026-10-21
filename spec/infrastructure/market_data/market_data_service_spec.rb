require "spec_helper"
require_relative "../../../lib/infrastructure/market_data/market_data_service"

RSpec.describe MarketDataService do
  subject(:market_data_service) do
    described_class.new(provider: provider)
  end

  let(:provider) { double("MarketDataProvider") }

  describe "#price_for" do
    it "delegates the stock price lookup to the provider" do
      expect(provider)
        .to receive(:price_for)
        .with("PETR4")
        .and_return(56.00)

      expect(market_data_service.price_for("PETR4")).to eq(56.00)
    end
  end
end