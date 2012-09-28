require 'spec_helper'

describe TableCloth::Presenter do
  let(:dummy_table) { Class.new(DummyTable) }
  let(:dummy_model) do
    DummyModel.new.tap do |d|
      d.id    = 1
      d.email = 'robert@example.com'
      d.name  = 'robert'
    end
  end

  let(:objects) do
    3.times.map do |n|
      num = n+1
      DummyModel.new.tap do |d|
        d.id    = num # Wat
        d.email = "robert#{num}@example.com"
        d.name  = "robert#{num}"
      end 
    end
  end

  let(:view_context) { ActionView::Base.new }
  subject { TableCloth::Presenter.new(objects, dummy_table, view_context) }

  it 'returns names' do
    subject.column_names.should == ['Id', 'Name', 'Email']
  end

  it 'returns a column for actions if given' do
    dummy_table.action(:edit) { '/model/1/edit' }
    presenter = TableCloth::Presenter.new(objects, dummy_table, view_context)    

    presenter.column_names.should include "Actions"
  end

  it 'returns all values for a row' do
    subject.row_values(dummy_model).should == [1, 'robert', 'robert@example.com']
  end

  it 'returns an edit link in the actions column' do
    dummy_table.action(:edit) { '/model/1/edit' }
    presenter = TableCloth::Presenter.new(objects, dummy_table, view_context)    

    column = Nokogiri::HTML(presenter.row_values(dummy_model).last)
    column.at_xpath('//a')[:href].should == '/model/1/edit'
  end

  it 'generates the values for all of the rows' do
    subject.rows.should == [
      [1, 'robert1', 'robert1@example.com'],
      [2, 'robert2', 'robert2@example.com'],
      [3, 'robert3', 'robert3@example.com']
    ]
  end
end