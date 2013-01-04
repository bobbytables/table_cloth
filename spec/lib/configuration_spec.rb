require 'spec_helper'

describe TableCloth::Configuration do
  subject { TableCloth::Configuration.new }
  let(:options) { TableCloth::Configuration::OPTIONS }

  it "has accessors for all options" do
    options.each do |option|
      expect(subject).to respond_to option
    end
  end
end