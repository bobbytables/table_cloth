require "spec_helper"

describe TableCloth::Actions do
  subject { TableCloth::Actions }

  context "block syntax" do

    it "accepts a block" do
      actions = subject.new do
        action { 'Edit' }
      end

      actions.column.should have(1).actions
    end

    it "accepts options with a block" do
      expect do
        subject.new(class: "actions") do
          action { "Edit" }
        end
      end.not_to raise_error
    end

    it ".all returns all actions for the column" do
      actions = subject.new { action { "Edit" } }
      actions.should have(1).all
    end
  end
end