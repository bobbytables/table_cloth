require 'spec_helper'

describe TableCloth::Configuration do
  subject { Class.new(TableCloth::Configuration) }

  context "options" do
    TableCloth::Configuration::OPTIONS.each do |option|
      it "configures #{option} options" do
        subject.send(option).classes = "option_value"
        expect(subject.send(option).classes).to eq("option_value")
      end
    end
  end

  context "[] accessor" do
    let(:option) { TableCloth::Configuration::OPTIONS.first }

    it "returns the option" do
      subject.send(option).classes = "something"
      expect(subject.new[option].classes).to eq("something")
    end
  end
end