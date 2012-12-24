require "spec_helper"

describe TableCloth::Extensions::Actions::Column do
  let(:view_context) { ActionView::Base.new }
  let(:dummy_model) { FactoryGirl.build(:dummy_model) }
  let(:action_collection) { TableCloth::Extensions::Actions::ActionCollection.new }

  subject { described_class.new(:actions, collection: action_collection) }

  context "value" do
    it "returns action values" do
      action_collection.action { "something" }
      expect(subject.value(dummy_model, view_context)).to match /something/
    end

    it "returns multiple action values" do
      action_collection.action { "something" }
      action_collection.action { "else" }
      expect(subject.value(dummy_model, view_context)).to match /something/
      expect(subject.value(dummy_model, view_context)).to match /else/
    end
  end
end