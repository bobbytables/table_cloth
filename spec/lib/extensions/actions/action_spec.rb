require "spec_helper"

describe TableCloth::Extensions::Actions::Action do
  let(:action_hash) { Hash.new(block: Proc.new{}) }
  it "initializes with a hash" do
    action = described_class.new(action_hash)
    expect(action.options).to eq(action_hash)
  end
end