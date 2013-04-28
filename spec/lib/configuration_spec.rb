require 'spec_helper'

describe TableCloth::Configuration do
  subject { TableCloth::Configuration.new }

  context "element options" do
    TableCloth::Configuration::ELEMENT_OPTIONS.each do |option|
      it "has an accessor for #{option}" do
        expect(subject).to respond_to option
      end
    end
  end

  context "general options" do
    TableCloth::Configuration::GENERAL_OPTIONS.each do |option|
      it "has an accessor for #{option}" do
        expect(subject).to respond_to option
      end
    end
  end

  specify ".configure returns the TableCloth global config" do
    config = double("config")
    TableCloth.stub config: config
    expect {|b| described_class.configure(&b) }.to yield_with_args(config)
  end
end