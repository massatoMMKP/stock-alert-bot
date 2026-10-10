require "spec_helper"
require "uri"
require_relative "../../../lib/infrastructure/notifications/telegram_provider"

RSpec.describe TelegramProvider do
  subject(:provider) do
    described_class.new(
      token: "fake-token",
      chat_id: "123456",
      http_client: http_client
    )
  end

  let(:http_client) { double("HTTP Client") }

  describe "#send_message" do
    context "when Telegram accepts the message" do
      let(:response) do
        double(
          "Response",
          code: "200",
          body: '{"ok":true}'
        )
      end

      it "sends the message to the Telegram API" do
        expect(http_client)
          .to receive(:post_form)
          .with(
            URI("https://api.telegram.org/botfake-token/sendMessage"),
            {
              "chat_id" => "123456",
              "text" => "PETR4 atingiu R$ 56.00"
            }
          )
          .and_return(response)

        provider.send_message("PETR4 atingiu R$ 56.00")
      end
    end

    context "when Telegram returns an HTTP error" do
      let(:response) do
        double("Response", code: "500")
      end

      it "raises an API error" do
        allow(http_client)
          .to receive(:post_form)
          .and_return(response)

        expect {
          provider.send_message("PETR4 atingiu R$ 56.00")
        }.to raise_error(
          TelegramProvider::APIError,
          "Telegram request failed with status 500"
        )
      end
    end

    context "when Telegram rejects the message" do
      let(:response) do
        double(
          "Response",
          code: "200",
          body: '{"ok":false}'
        )
      end

      it "raises an API error" do
        allow(http_client)
          .to receive(:post_form)
          .and_return(response)

        expect {
          provider.send_message("PETR4 atingiu R$ 56.00")
        }.to raise_error(
          TelegramProvider::APIError,
          "Telegram rejected the message"
        )
      end
    end

    context "when Telegram returns invalid JSON" do
      let(:response) do
        double(
          "Response",
          code: "200",
          body: "invalid json"
        )
      end

      it "raises an API error" do
        allow(http_client)
          .to receive(:post_form)
          .and_return(response)

        expect {
          provider.send_message("PETR4 atingiu R$ 56.00")
        }.to raise_error(
          TelegramProvider::APIError,
          "Invalid Telegram response"
        )
      end
    end
  end
end