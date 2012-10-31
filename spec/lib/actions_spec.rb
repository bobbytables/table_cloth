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
  end
end