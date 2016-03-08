require 'byebug'

class Order

  BILL = 0
  TAX_RATE = 0.0864

  attr_reader :items, :total, :menu

  def initialize
    @items = []
    @total = BILL
    @menu = {}
  end

  def add_item(product)
    items << product
  end

  def prices(products)
    products.each do |product, price|
      @menu[product] = price
    end
  end

  def subtotal
    @subtotal = @menu.inject(0) { |product, price| product + price.last }.round(2)
  end

  def tax_amount
    (subtotal * TAX_RATE).round(2)
  end

  def total_amount
    @total = (subtotal + tax_amount).round(2)
  end

  def print_receipt
    {
      items: @items,
      tax: "Tax: #{tax_amount}",
      total: "Total: #{total_amount}"
    }
  end

  def payment(money)
    @cash = money
  end
end
