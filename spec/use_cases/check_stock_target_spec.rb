require "spec_helper"
require_relative "../../lib/domain/stock"
require_relative "../../lib/use_cases/check_stock_target"

RSpec.describe CheckStockTarget do
  subject(:use_case) do
    described_class.new(
      market_data: market_data,
      notifier: notifier
    )
  end

  let(:stock) do
    Stock.new(
      ticker: "WEGE3",
      purchase_price: 40.00,
      target_percentage: 20
    )
  end

  let(:market_data) { double("MarketData") }
  let(:notifier) { double("Notifier") }

  describe "#call" do
    context "when the percentage target is reached" do
      it "sends a notification" do
        allow(market_data)
          .to receive(:price_for)
          .with("WEGE3")
          .and_return(48.00)

        expect(notifier)
          .to receive(:notify)
          .with(stock, 48.00)

        use_case.call(stock)
      end
    end

    context "when the percentage target is not reached" do
      it "does not send a notification" do
        allow(market_data)
          .to receive(:price_for)
          .with("WEGE3")
          .and_return(45.00)

        expect(notifier).not_to receive(:notify)

        use_case.call(stock)
      end
    end
  end
end