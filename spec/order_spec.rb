require 'order'

describe Order do

  subject(:order) { described_class.new }

  it "starts with no items" do
    expect(order.items).to eq([])
  end

  it "starts the bill total at 0" do
    expect(order.total).to eq(0)
  end

  it "adds items" do
    order.add_item('Coffee')
    order.add_item('Cafe Latte')
    expect(order.items).to eq(['Coffee', 'Cafe Latte'])
  end

  it 'has an empty menu at the start' do
    expect(order.menu).to eq({})
  end

  it "creates a menu" do
    order.prices('Coffee' => 3.65)
    order.prices('Cafe Latte' => 3.99)
    expect(order.menu).to eq('Coffee' => 3.65 ,'Cafe Latte' => 3.99)
  end

  it "starts subtotal at 0" do
    expect(order.subtotal).to eq(0)
  end

  it "creates a subtotal" do
    order.prices('Coffee' => 3.65)
    order.prices('Cafe Latte' => 3.99)
    expect(order.subtotal).to eq(7.64)
  end

  it "calculates the amount of tax" do
    order.prices('Coffee' => 3.65)
    order.prices('Cafe Latte' => 3.99)
    expect(order.subtotal).to eq(7.64)
    expect(order.tax_amount).to eq(0.66)
  end

  it "calculates the total bill" do
    order.add_item('Coffee')
    order.add_item('Cafe Latte')
    order.prices('Coffee' => 3.65)
    order.prices('Cafe Latte' => 3.99)
    expect(order.items).to eq(['Coffee', 'Cafe Latte'])
    expect(order.total_amount).to eq(8.30)
  end

  it 'prints the receipt' do
    order.add_item('Coffee')
    order.add_item('Cafe Latte')
    order.prices('Coffee' => 3.65)
    order.prices('Cafe Latte' => 3.98)
    expect(order.print_receipt).to eq({:items=>["Coffee", "Cafe Latte"],
                                         :tax=>"Tax: 0.66",
                                         :total=>"Total: 8.29"})
  end

  it "takes payment" do
    expect(order.payment(20)).to eq(20)
  end
end