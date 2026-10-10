require "spec_helper"
require "json"
require_relative "../../lib/infrastructure/market_data"

RSpec.describe MarketData do
  subject(:market_data) do
    described_class.new(http_client: http_client)
  end

  let(:http_client) { double("HTTP Client") }

  before do
    allow(http_client)
      .to receive(:get_response)
      .and_return(response)
  end

  describe "#price_for" do
    context "when the API returns a valid stock price" do
      let(:response) do
        double(
          "Response",
          code: "200",
          body: {
            results: [
              {
                symbol: "PETR4",
                regularMarketPrice: 35.50
              }
            ]
          }.to_json
        )
      end

      it "returns the current price" do
        expect(market_data.price_for("PETR4")).to eq(35.50)
      end
    end

    context "when the API returns an HTTP error" do
      let(:response) do
        double("Response", code: "500")
      end

      it "raises an API error with the HTTP status code" do
        expect {
          market_data.price_for("PETR4")
        }.to raise_error(
          MarketData::APIError,
          "API request failed with status 500"
        )
      end
    end

    context "when the API returns no stock data" do
      let(:response) do
        double(
          "Response",
          code: "200",
          body: { results: [] }.to_json
        )
      end

      it "raises a stock not found error" do
        expect {
          market_data.price_for("INVALID")
        }.to raise_error(
          MarketData::StockNotFoundError,
          "Stock INVALID not found"
        )
      end
    end
  end
end