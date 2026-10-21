require "net/http"
require "json"
require "uri"
require_relative "market_data_provider"
require_relative "market_data_errors"

class BrapiProvider
  include MarketDataProvider

  API_URL = "https://brapi.dev/api/quote"

  def initialize(http_client: Net::HTTP, token: nil)
    @http_client = http_client
    @token = token
  end

  def price_for(ticker)
    uri = URI("#{API_URL}/#{ticker}")
    response = fetch_response(uri)

    unless response.code == "200"
      raise MarketDataError, "API request failed with status #{response.code}"
    end

    stock = JSON.parse(response.body).fetch("results").first

    raise StockNotFoundError, "Stock #{ticker} not found" unless stock

    stock.fetch("regularMarketPrice")
  end

  private

  def fetch_response(uri)
    return @http_client.get_response(uri) unless @token

    @http_client.get_response(
      uri,
      { "Authorization" => "Bearer #{@token}" }
    )
  end
end