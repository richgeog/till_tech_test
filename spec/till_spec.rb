require 'till'

describe Till do
  it "adds items" do
    subject.add_item(:tea)
    expect(subject.items).to eq [:tea]
  end

  it "starts the bill total at 0" do
    expect(subject.total).to eq (0)
  end

  it "calculates the total bill" do
    subject.add_item(:tea)
    subject.calculate_total(3.65)
    expect(subject.total).to eq (3.65)
  end

  it "calculates the tax amount" do
    subject.add_item(:tea)
    subject.calculate_total(3.65)
    expect(subject.tax_amount{calculate_total}).to eq (0.32)
  end
end