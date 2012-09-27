require 'spec_helper'

describe TableCloth::Base do
  subject { Class.new(TableCloth::Base) }

  context 'columns' do
    it 'has a column method' do
      subject.should respond_to :column
    end

    it 'column accepts a name' do
      expect { subject.column :column_name }.not_to raise_error
    end

    it 'column accepts options' do
      expect { subject.column :n, {option: 'value'} }.not_to raise_error
    end

    it '.columns returns all columns' do
      subject.column :name
      subject.columns.size.should == 1
    end
  end
end