require "net/http"
require "json"
require "uri"

class MarketData
  class APIError < StandardError; end
  class StockNotFoundError < StandardError; end

  API_URL = "https://brapi.dev/api/quote"

  def initialize(http_client: Net::HTTP)
    @http_client = http_client
  end

  def price_for(ticker)
    uri = URI("#{API_URL}/#{ticker}")

    response = @http_client.get_response(uri)

    unless response.code == "200"
      raise APIError, "API request failed with status #{response.code}"
    end

    data = JSON.parse(response.body)

    stock_data = data.fetch("results").first

    unless stock_data
      raise StockNotFoundError, "Stock #{ticker} not found"
    end

    stock_data.fetch("regularMarketPrice")
  end
end