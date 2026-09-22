require "spec_helper"
require_relative "../../lib/domain/stock"

RSpec.describe Stock do
  subject(:stock) do
    described_class.new(
      ticker: "WEGE3",
      purchase_price: 40.00,
      target_percentage: 20
    )
  end

  describe "#target_reached?" do
    context "when the current price reaches the target percentage" do
      it "returns true" do
        expect(stock.target_reached?(48.00)).to be true
      end
    end

    context "when the current price is below the target percentage" do
      it "returns false" do
        expect(stock.target_reached?(47.00)).to be false
      end
    end
  end
end