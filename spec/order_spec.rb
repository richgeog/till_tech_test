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
end