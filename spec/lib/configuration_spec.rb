require 'spec_helper'

describe TableCloth::Configuration do
  subject { TableCloth::Configuration.new }
  let(:options) { TableCloth::Configuration::OPTIONS }

  it "has accessors for all options" do
    options.each do |option|
      expect(subject).to respond_to option
    end
  end

  specify ".configure returns the TableCloth global config" do
    config = double("config")
    TableCloth.stub config: config
    expect {|b| described_class.configure(&b) }.to yield_with_args(config)
  end
end