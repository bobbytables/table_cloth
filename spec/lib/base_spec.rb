require 'spec_helper'

describe TableCloth::Base do
  subject { Class.new(TableCloth::Base) }
  let(:view_context) { ActionView::Base.new }

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

    it 'excepts multiple column names' do
      subject.column :name, :email
      subject.columns.size.should == 2
    end

    it 'stores a proc if given in options' do
      subject.column(:name) { 'Wee' }

      column = subject.columns[:name]
      column.options[:proc].should be_present
      column.options[:proc].should be_kind_of(Proc)
    end
  end

  context 'presenters' do
    it 'has a presenter method' do
      subject.should respond_to :presenter
    end
  end

  context 'actions' do
    it 'has an action method' do
      subject.should respond_to :action
    end

    it 'it adds an acion' do
      subject.action :edit
      subject.actions.length.should == 1
    end
  end
end