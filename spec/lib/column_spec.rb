require 'spec_helper'

describe TableCloth::Column do
  subject { Class.new(TableCloth::Column) }
  let(:view_context) { ActionView::Base.new }
  let(:dummy_model) do
    DummyModel.new.tap do |d|
      d.id    = 1
      d.email = 'robert@example.com'
      d.name  = 'robert'
    end
  end

  context 'values' do
    let(:name_column) do 
      TableCloth::Column.new(:name)
    end

    let(:email_column) do
      proc = lambda {|object, view|
        object.email
      }

      TableCloth::Column.new(:my_email, proc: proc)
    end

    it 'returns the name correctly' do
      name_column.value(dummy_model, view_context).should == 'robert'
    end

    it 'returns the email from a proc correctly' do
      email_column.value(dummy_model, view_context).should == 'robert@example.com'
    end

    context '.available?' do
      let(:dummy_table) do
        Class.new(TableCloth::Table) do
          column :name, if: :admin?

          def admin?
            view.admin?
          end
        end
      end

      it 'returns true on successful constraint' do
        table  = Class.new(DummyTable).new([dummy_model], view_context)
        column = TableCloth::Column.new(:name, if: :admin?)
        column.available?(table).should be_true
      end
    end
  end
end