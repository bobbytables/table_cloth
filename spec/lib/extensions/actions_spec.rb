require "spec_helper"

describe TableCloth::Extensions::Actions do
  let(:dummy_table) { FactoryGirl.build(:dummy_table) }

  describe '.actions' do
    it "yields an ActionCollection block" do
      block_type = nil
      dummy_table.actions { block_type = self }
      expect(block_type).to be_kind_of TableCloth::Extensions::Actions::ActionCollection
    end

    it "creates an actions column on the table" do
      dummy_table.actions { }
      expect(dummy_table.columns).to have_key :actions
    end

    it "accepts options" do
      dummy_table.actions(if: :admin?) { }
      expect(dummy_table.columns[:actions][:options]).to have_key :if
    end

    it "sets a collection key for the column pointing to the collection object" do
      dummy_table.actions { }
      expect(dummy_table.columns[:actions][:options][:collection]).to be_kind_of TableCloth::Extensions::Actions::ActionCollection
    end

    it "sets the column class to an action column" do
      dummy_table.actions { }
      column = dummy_table.columns[:actions]
      expect(column[:class]).to eq(TableCloth::Extensions::Actions::Column)
    end
  end
end
