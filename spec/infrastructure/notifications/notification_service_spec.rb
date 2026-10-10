require "spec_helper"
require_relative "../../../lib/infrastructure/notifications/notification_service"

RSpec.describe NotificationService do
  subject(:notification_service) do
    described_class.new(provider: provider)
  end

  let(:provider) { instance_double("TelegramProvider") }

  let(:stock) do
    double("Stock", ticker: "PETR4")
  end

  describe "#notify" do
    it "delegates the formatted message to the provider" do
      expect(provider)
        .to receive(:send_message)
        .with("PETR4 atingiu R$ 56.00")

      notification_service.notify(stock, 56.00)
    end
  end
end