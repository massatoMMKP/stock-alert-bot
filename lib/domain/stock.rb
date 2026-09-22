class Stock
  def initialize(ticker:, purchase_price:, target_percentage:)
    @ticker = ticker
    @purchase_price = purchase_price
    @target_percentage = target_percentage
  end

  def target_reached?(current_price)
    percentage_change(current_price) >= @target_percentage
  end

  private

  def percentage_change(current_price)
    ((current_price - @purchase_price) / @purchase_price) * 100
  end
end