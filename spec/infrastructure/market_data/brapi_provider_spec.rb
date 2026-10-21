require "spec_helper"
require "json"
require "uri"
require_relative "../../../lib/infrastructure/market_data/brapi_provider"

RSpec.describe BrapiProvider do
  subject(:provider) do
    described_class.new(
      http_client: http_client,
      token: token
    )
  end

  let(:http_client) { double("HTTP Client") }
  let(:token) { nil }

  let(:response) do
    double(
      "Response",
      code: "200",
      body: {
        results: [
          {
            symbol: "PETR4",
            regularMarketPrice: 56.00
          }
        ]
      }.to_json
    )
  end

  describe "#price_for" do
    context "when the API returns a valid stock price" do
      it "returns the current price" do
        expect(http_client)
          .to receive(:get_response)
          .with(URI("https://brapi.dev/api/quote/PETR4"))
          .and_return(response)

        expect(provider.price_for("PETR4")).to eq(56.00)
      end
    end

    context "when an API token is provided" do
      let(:token) { "fake-token" }

      it "sends the authorization header" do
        expect(http_client)
          .to receive(:get_response)
          .with(
            URI("https://brapi.dev/api/quote/PETR4"),
            { "Authorization" => "Bearer fake-token" }
          )
          .and_return(response)

        expect(provider.price_for("PETR4")).to eq(56.00)
      end
    end

    context "when the API returns an HTTP error" do
      let(:response) do
        double("Response", code: "401")
      end

      it "raises an API error" do
        allow(http_client)
          .to receive(:get_response)
          .and_return(response)

        expect {
          provider.price_for("WEGE3")
        }.to raise_error(
          MarketDataError,
          "API request failed with status 401"
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
        allow(http_client)
          .to receive(:get_response)
          .and_return(response)

        expect {
          provider.price_for("INVALID")
        }.to raise_error(
          StockNotFoundError,
          "Stock INVALID not found"
        )
      end
    end
  end
end