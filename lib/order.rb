class Order

  BILL = 0
  TAX = 0.0864

  attr_reader :items, :total, :menu

  def initialize
    @items = []
    @total = BILL
    @menu = {}
    # @subtotal = 0
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
    (subtotal * TAX).round(2)
  end
end
