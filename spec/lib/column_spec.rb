require 'spec_helper'

describe TableCloth::Column do
  subject { Class.new(TableCloth::Column) }
  let(:view_context) { ActionView::Base.new }

  context 'values' do
    let(:name_column) do 
      TableCloth::Column.new(:name)
    end

    let(:email_column) do
      proc = lambda {|object, options, view|
        object.email
      }

      TableCloth::Column.new(:my_email, proc: proc)
    end

    context 'conditionals' do
      let(:email_column_if) do
        TableCloth::Column.new(:email, if: :admin?)
      end

      let(:email_column_unless) do
        TableCloth::Column.new(:email, unless: :admin?)
      end

      let(:model) do
        DummyModel.new.tap do |d|
          d.id    = 1
          d.email = 'robert@example.com'
          d.name  = 'robert'
        end
      end

      it 'returns the name correctly' do
        name_column.value(model, view_context).should == 'robert'
      end

      it 'returns the email from a proc correctly' do
        email_column.value(model, view_context).should == 'robert@example.com'
      end

      it 'does not return the email if they are not an admin' do
        email_column_if.value(model, view_context).should be_blank
      end

      it 'returns the email if they are an admin' do
        model.admin = true
        email_column_if.value(model, view_context).should == 'robert@example.com'
      end

      it 'does return the email unless they are an admin' do
        model.admin = false
        email_column_unless.value(model, view_context).should == 'robert@example.com'
      end

      it 'does return the email unless they are an admin' do
        model.admin = true
        email_column_unless.value(model, view_context).should be_blank
      end
    end
  end
end