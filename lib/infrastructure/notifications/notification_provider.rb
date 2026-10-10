module NotificationProvider
  def send_message(message)
    raise NotImplementedError, "Providers must implement #send_message"
  end
end