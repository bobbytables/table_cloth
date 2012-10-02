require 'spec_helper'

describe 'Action View Extension' do
  let(:action_view) { ActionView::Base.new }
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

  it 'includes to actionview' do
    action_view.should respond_to :simple_table_for
  end

  it '.simple_table_for renders a table' do
    table = action_view.simple_table_for(objects) do |table|
      table.column :name, :email
    end

    doc = Nokogiri::HTML(table)
    doc.at_xpath('//table').should be_present
    doc.at_xpath('//tr').xpath('.//th').length.should == 2

    trs = doc.at_xpath('//tbody').xpath('.//tr').to_a
    trs.each_with_index do |tr, index|
      tds = tr.xpath('.//td')
      objects[index].name.should  == tds[0].text
      objects[index].email.should == tds[1].text
    end
  end
end