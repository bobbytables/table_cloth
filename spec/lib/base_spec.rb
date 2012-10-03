require 'spec_helper'

describe TableCloth::Base do
  subject { Class.new(TableCloth::Base) }
  let(:view_context) { ActionView::Base.new }
  let(:dummy_model) do
    DummyModel.new.tap do |d|
      d.id    = 1
      d.email = 'robert@example.com'
      d.name  = 'robert'
    end
  end

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

    it '.column_names returns all names' do
      subject.column :name, :email
      subject.new([], view_context).column_names.should == ['Name', 'Email']
    end

    it '.column_names includes actions when given' do
      subject.action { '/' }
      subject.new([], view_context).column_names.should include 'Actions'
    end

    it '.column_names uses a name given to it' do
      subject.column :email, label: 'Email Address'
      subject.new([], view_context).column_names.should include 'Email Address'
    end

    it '.column can take a custom column' do
      email_column = Class.new(TableCloth::Column) do
        def value(object, view)
          "AN EMAIL!"
        end
      end

      subject.column :email, using: email_column
      subject.new([dummy_model], view_context)

      subject.columns[:email].value(dummy_model, view_context).should == "AN EMAIL!"
    end
  end

  context 'conditions' do
    context 'if' do
      subject { DummyTable.new([dummy_model], view_context) }

      it 'includes the id column when admin' do
        subject.column_names.should include 'Id'
      end

      it 'exclused the id column when an admin' do
        def subject.admin?
          false
        end

        subject.column_names.should_not include 'Id'
      end
    end

    context 'unless' do
      subject { DummyTableUnlessAdmin.new([dummy_model], view_context) }
      before(:each) do
        def subject.admin?
          false
        end
      end

      it 'includes the id when not an admin' do
        subject.column_names.should include 'Id'
      end
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
      subject.action { '/' }
      subject.columns[:actions].actions.size.should == 1
    end
  end
end