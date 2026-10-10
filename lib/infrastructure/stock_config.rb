require "yaml"
require_relative "../domain/stock"

class StockConfig
  def initialize(path:)
    @path = path
  end

  def load
    config = YAML.safe_load_file(@path)

    config.fetch("stocks").map do |attributes|
      build_stock(attributes)
    end
  end

  private

  def build_stock(attributes)
    Stock.new(
      ticker: attributes.fetch("ticker"),
      purchase_price: attributes.fetch("purchase_price"),
      target_percentage: attributes.fetch("target_percentage")
    )
  end
end