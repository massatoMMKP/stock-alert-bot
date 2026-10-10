class NotificationService
  def initialize(provider:)
    @provider = provider
  end

  def notify(stock, current_price)
    message = "#{stock.ticker} atingiu R$ #{format('%.2f', current_price)}"

    @provider.send_message(message)
  end
end