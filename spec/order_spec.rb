require 'order'

describe Order do
  it "starts with no items" do
    expect(subject.items).to eq([])
  end

  it "starts the bill total at 0" do
    expect(subject.total).to eq(0)
  end

  it "adds items" do
    subject.add_item(:tea, 3.65)
    expect(subject.items).to eq([:tea])
    expect(subject.total).to eq(3.65)
  end

  it "calculates the tax amount" do
    subject.add_item(:tea, 3.65)
    expect(subject.tax_amount).to eq(0.32)
  end

  it "calculates the total amount" do
    subject.add_item(:tea, 3.65)
    expect(subject.calculate_total).to eq(3.97)
  end
end