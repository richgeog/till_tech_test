class Order

  BILL = 0
  TAX = 0.0864

  attr_reader :items, :total

  def initialize
    @items = []
    @total = BILL
  end

  def add_item(product, amount)
    items << product
    (@total += amount).round(2)
  end

  def tax_amount
    (@total * TAX).round(2)
  end

  def calculate_total
    (@total += tax_amount).round(2)
  end
end
