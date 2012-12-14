require "spec_helper"

describe TableCloth::Actions do
  subject { TableCloth::Actions }

  context "block syntax" do
    it "accepts a block" do
      actions = subject.new do
        action { 'Edit' }
      end

      expect(actions.column).to have(1).actions
    end

    it "accepts options with a block" do
      actions = subject.new(class: "actions") do
        action { "Edit" }
      end

      expect(actions.options[:class]).to eq("actions")
    end

    it ".all returns all actions for the column" do
      actions = subject.new { action { "Edit" } }
      expect(actions.all.length).to be 1
    end
  end
end