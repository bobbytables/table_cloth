require 'spec_helper'

describe TableCloth::Base do
  subject { Class.new(TableCloth::Base) }
  let(:view_context) { ActionView::Base.new }
  let(:dummy_model) { FactoryGirl.build(:dummy_model) }
  let(:table_instance) { subject.new([], view_context) }

  context 'columns' do
    it 'has a column method' do
      expect(subject).to respond_to :column
    end

    it 'column accepts a name' do
      expect { subject.column :column_name }.not_to raise_error
    end

    it 'column accepts options' do
      expect { subject.column :n, {option: 'value'} }.not_to raise_error
    end

    it '.columns returns all columns' do
      subject.column :name
      expect(subject).to have(1).columns
    end

    it 'accepts multiple column names' do
      subject.column :name, :email
      expect(subject).to have(2).columns
    end

    it 'stores a proc if given in options' do
      subject.column(:name) { 'Wee' }

      column = subject.columns[:name]
      expect(column.options[:proc]).to be_present
      expect(column.options[:proc]).to be_kind_of(Proc)
    end

    context ".column_names" do
      before(:each) { table_instance.stub admin?: false, awesome?: true }

      it 'returns all names' do
        subject.column :name, :email
        table_instance.column_names.should =~ ['Name', 'Email']
      end

      it 'includes actions when given' do
        subject.actions { action { } }
        table_instance.column_names.should include 'Actions'
      end

      it 'does not include actions if all action conditions fail' do
        subject.actions do
          action(if: :admin?) { '/' }
        end
        table_instance.column_names.should_not include 'Actions'
      end

      it 'include actions when only partial are available' do
        subject.actions do
          action(if: :admin?) { '/' }
          action(if: :awesome?) { '/' }
        end
        table_instance.column_names.should include 'Actions'  
      end

      it 'uses a name given to it' do
        subject.column :email, label: 'Email Address'
        table_instance.column_names.should include 'Email Address'
      end
    end

    context "custom" do
      let(:custom_column) do
        Class.new(TableCloth::Column) do
          def value(object, view)
            "AN EMAIL!"
          end
        end
      end

      it '.column can take a custom column' do
        subject.column :email, using: custom_column
        subject.columns[:email].value(dummy_model, view_context).should == "AN EMAIL!"
      end
    end
  end

  context 'conditions' do
    context 'if' do
      subject { DummyTable.new([dummy_model], view_context) }

      it 'includes the id column when admin' do
        subject.column_names.should include 'Id'
      end

      it 'exclused the id column when an admin' do
        subject.stub admin?: false
        subject.column_names.should_not include 'Id'
      end
    end

    context 'unless' do
      subject { DummyTableUnlessAdmin.new([dummy_model], view_context) }
      before(:each) do
        subject.stub admin?: false
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
    it "takes a block" do
      subject.actions do
        action { 'Edit' }
        action { 'Delete' }
      end

      subject.columns[:actions].should have(2).actions
    end
  end

  context "configuration" do
    subject { Class.new(TableCloth::Base) }
    let(:sibling1_class) { Class.new(subject) }
    let(:sibling2_class) { Class.new(subject) }

    it "allows configuration" do
      expect { subject.config.table.cellpadding = '0' }.to change { subject.config.table.cellpadding }.to('0')
    end

    it "doesn't interfere with configuration of parent classes" do
      expect { sibling1_class.config.table.cellpadding = '0' }.not_to change { sibling2_class.config.table.cellpadding }
    end
  end
end