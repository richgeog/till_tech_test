require 'till'

describe Till do
  it "adds items" do
    subject.add_item(:tea)
    expect(subject.items).to eq [:tea]
  end

  it "calculates the total bill" do
    subject.calculate_total(3.65)
    expect(subject.total).to eq (3.65)
  end

  it "starts the bill total at 0" do
    expect(subject.total).to eq (0)
  end

  it "knows how much tax is" do
    expect(subject.tax).to eq (8.64)
  end
end