require "spec_helper"

describe TableCloth::Extensions::Actions::Action do
  let(:action_hash) { Hash.new(block: Proc.new{}) }
  subject { described_class.new(action_hash) }

  it "initializes with a hash" do
    expect(subject.options).to eq(action_hash)
  end

  it "defines a delegator to a jury" do
    expect(subject.jury).to be_kind_of TableCloth::Extensions::Actions::Jury
  end
end