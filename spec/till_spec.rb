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
end