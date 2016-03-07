require 'order'

describe Order do
  it "starts with no items" do
    expect(subject.items).to eq([])
  end

  it "starts the bill total at 0" do
    expect(subject.total).to eq(0)
  end

  it "adds items" do
    subject.add_item('Coffee')
    subject.add_item('Cafe Latte')
    expect(subject.items).to eq(['Coffee', 'Cafe Latte'])
  end

  it "creates a menu" do
    subject.prices('Coffee' => 3.65)
    subject.prices('Cafe Latte' => 3.99)
    expect(subject.menu).to eq('Coffee' => 3.65 ,'Cafe Latte' => 3.99)
  end
end