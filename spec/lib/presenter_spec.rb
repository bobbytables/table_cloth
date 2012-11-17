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

  it 'returns all values for a row' do
    subject.row_values(dummy_model).should == [1, 'robert', 'robert@example.com']
  end

  it 'returns an edit link in the actions column' do
    dummy_table.actions do
      action {|object, view| link_to 'Edit', '/model/1/edit' }
    end
    presenter = TableCloth::Presenter.new(objects, dummy_table, view_context)    

    actions_value = presenter.row_values(dummy_model).last
    column = Nokogiri::HTML(actions_value)
    column.at_xpath('//a')[:href].should == '/model/1/edit'
    column.at_xpath('//a').text.should == 'Edit'
  end

  it 'generates the values for all of the rows' do
    subject.rows.should == [
      [1, 'robert1', 'robert1@example.com'],
      [2, 'robert2', 'robert2@example.com'],
      [3, 'robert3', 'robert3@example.com']
    ]
  end

  context 'tags' do
    it '.wrapper_tag includes config for a tag in block form' do
      TableCloth::Configuration.table.should_receive(:to_hash).and_return(class: "stuff")
      table = subject.wrapper_tag(:table) { "Hello "}
      Nokogiri::HTML(table).at_xpath('//table')[:class].should == 'stuff'
    end

    it '.wrapper_tag includes config for a tag without a block' do
      TableCloth::Configuration.table.should_receive(:to_hash).and_return(class: "stuff")
      table = subject.wrapper_tag(:table, 'Hello')
      Nokogiri::HTML(table).at_xpath('//table')[:class].should == 'stuff'
    end
  end
end