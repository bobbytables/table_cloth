require "spec_helper"

describe TableCloth::Extensions::Actions::Action do
  let(:action_hash) { {proc: Proc.new{}} }
  subject { described_class.new(action_hash) }

  it "initializes with a hash" do
    expect(subject.options).to eq(action_hash)
  end

  it "defines a delegator to a jury" do
    expect(subject.jury).to be_kind_of TableCloth::Extensions::Actions::Jury
  end

  context "#value" do
    let(:model) { FactoryGirl.build(:dummy_model) }
    let(:view_context) { ActionView::Base.new }
    let(:table) { TableCloth::Base.new(nil, nil) }

    context "string" do
      let(:action_hash) { {proc: Proc.new{ "something" }} }

      it "returns a string" do
        expect(subject.value(model, view_context, table)).to match /something/
      end
    end

    context "view helper" do
      let(:action_hash) do
        {proc: Proc.new { link_to "blank", "something" }}
      end

      it "returns a link" do
        expect(subject.value(model, view_context, table)).to match /href="something"/
        expect(subject.value(model, view_context, table)).to match />blank</
      end
    end

    context "conditional" do
      let(:action_hash) do
        {
          proc: Proc.new { "something" },
          if: Proc.new {|object| object.admin? }
        }
      end

      it "returns the link when the model condition succeeds" do
        model.stub admin?: true
        expect(subject.value(model, view_context, table)).to include "something"
      end

      it "does not return the link when the model condition fails" do
        model.stub admin?: false
        expect(subject.value(model, view_context, table)).not_to include "something"
      end
    end
  end
end
