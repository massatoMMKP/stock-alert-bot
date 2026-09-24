class Stock
  attr_reader :ticker
  def initialize(ticker:, purchase_price:, target_percentage:, target_price: nil)
    @ticker = ticker
    @purchase_price = purchase_price
    @target_percentage = target_percentage
    @target_price = target_price
  end

  def target_reached?(current_price)
    percentage_change(current_price) >= @target_percentage
  end

  def price_target_reached?(current_price)
    current_price >= @target_price
  end

  private
  def percentage_change(current_price)
    ((current_price - @purchase_price) / @purchase_price) * 100
  end
end