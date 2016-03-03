class Till
  attr_reader :items
  def initialize
    @items = []
  end

  def add_item(product)
    items << product
  end
end
