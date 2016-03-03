class Till

  BILL = 0

  attr_reader :items, :total

  def initialize
    @items = []
    @total = BILL
  end

  def add_item(product)
    items << product
  end

  def calculate_total(amount)
    @total += amount
  end
end