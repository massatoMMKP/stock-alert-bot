require "spec_helper"
require "tempfile"
require_relative "../../lib/domain/stock"
require_relative "../../lib/infrastructure/stock_config"

RSpec.describe StockConfig do
  subject(:stock_config) { described_class.new(path: file.path) }

  let(:file) { Tempfile.new(["stocks", ".yml"]) }

  after do
    file.close!
  end

  describe "#load" do
    it "loads stocks from a YAML file" do
      file.write(<<~YAML)
        stocks:
          - ticker: PETR4
            purchase_price: 40.0
            target_percentage: 20

          - ticker: WEGE3
            purchase_price: 35.0
            target_percentage: 15
      YAML

      file.flush

      stocks = stock_config.load

      expect(stocks.size).to eq(2)
      expect(stocks.map(&:ticker)).to eq(["PETR4", "WEGE3"])
      expect(stocks).to all(be_a(Stock))
    end
  end
end