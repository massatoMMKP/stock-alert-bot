require "net/http"
require "uri"
require "json"
require_relative "notification_provider"

class TelegramProvider
  include NotificationProvider

  class APIError < StandardError; end

  API_URL = "https://api.telegram.org"

  def initialize(token:, chat_id:, http_client: Net::HTTP)
    @token = token
    @chat_id = chat_id
    @http_client = http_client
  end

  def send_message(message)
    uri = URI("#{API_URL}/bot#{@token}/sendMessage")

    response = @http_client.post_form(
      uri,
      {
        "chat_id" => @chat_id,
        "text" => message
      }
    )

    validate_response(response)
  end

  private

  def validate_response(response)
    unless response.code == "200"
      raise APIError, "Telegram request failed with status #{response.code}"
    end

    data = JSON.parse(response.body)

    raise APIError, "Telegram rejected the message" unless data["ok"]
  rescue JSON::ParserError
    raise APIError, "Invalid Telegram response"
  end
end