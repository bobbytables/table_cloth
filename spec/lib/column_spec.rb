require 'spec_helper'

describe TableCloth::Column do
  subject { Class.new(TableCloth::Column) }
  let(:view_context) { ActionView::Base.new }
  let(:dummy_model) { FactoryGirl.build(:dummy_model) }

  context 'values' do
    let(:proc) do
      lambda {|object, view| object.email.gsub("@", " at ")}
    end

    let(:name_column) { TableCloth::Column.new(:name) }
    let(:email_column) { TableCloth::Column.new(:my_email, proc: proc) }

    it 'returns the name correctly' do
      name_column.value(dummy_model, view_context).should == 'robert'
    end

    it 'returns the email from a proc correctly' do
      email_column.value(dummy_model, view_context).should == 'robert at example.com'
    end

    context '.available?' do
      it 'returns true on successful constraint' do
        table  = Class.new(DummyTable).new([dummy_model], view_context)
        column = TableCloth::Column.new(:name, if: :admin?)
        column.available?(table).should be_true
      end

      it 'returns false on failed constraints' do
        table  = Class.new(DummyTable).new([dummy_model], view_context)
        table.stub admin?: false


        column = TableCloth::Column.new(:name, if: :admin?)
        column.available?(table).should be_false
      end
    end
  end
end