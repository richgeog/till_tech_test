require 'till'

describe Till do
  it "adds items" do
    subject.add_item(:tea)
    expect(subject.items).to eq [:tea]
  end
end