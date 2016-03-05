class Order

  BILL = 0
  TAX = 0.0864

  attr_reader :items, :total

  def initialize
    @items = []
    @total = BILL
  end

  def add_item(product)
    items << product
  end
end
