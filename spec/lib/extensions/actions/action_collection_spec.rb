require "spec_helper"

describe TableCloth::Extensions::Actions::ActionCollection do
  subject { described_class.new }

  context "#action" do
    it "adds an action" do
      subject.action { }
      expect(subject).to have(1).actions
    end

    it "adds an action with options" do
      subject.action(option: "something") { }
      expect(subject.actions.first.options[:option]).to eq("something")
    end
  end

  context "#actions" do
    before(:each) do
      subject.action { }
    end

    it "returns a list of actions" do
      subject.actions.each do |action|
        expect(action).to be_kind_of TableCloth::Extensions::Actions::Action
      end
    end
  end
end