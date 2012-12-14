require 'spec_helper'

describe TableCloth::Presenter do
  subject { TableCloth::Presenter.new(objects, dummy_table, view_context) }
  let(:dummy_table) { Class.new(DummyTable) }
  let(:dummy_model) { FactoryGirl.build(:dummy_model) }

  let(:objects) { 3.times.map { FactoryGirl.build(:dummy_model) } }

  let(:view_context) { ActionView::Base.new }
  subject { TableCloth::Presenter.new(objects, dummy_table, view_context) }

  it 'returns all values for a row' do
    subject.row_values(dummy_model).should == [dummy_model.id, dummy_model.name, dummy_model.email]
  end

  it 'returns an edit link in the actions column' do
    dummy_table.actions do
      action {|object, view| link_to 'Edit', '/model/1/edit' }
    end

    actions_value = subject.row_values(dummy_model).last
    column = Nokogiri::HTML(actions_value)
    column.at_xpath('//a')[:href].should == '/model/1/edit'
    column.at_xpath('//a').text.should == 'Edit'
  end

  it 'generates the values for all of the rows' do
    expected = objects.map {|o| [o.id, o.name, o.email] }
    expect(subject.rows).to eq(expected)
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