require 'spec_helper'

describe TableCloth::Presenters::Default do
  let(:dummy_table) { DummyTable }
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
  subject { TableCloth::Presenters::Default.new(objects, dummy_table, view_context) }

  it 'creates a table head' do
    header = subject.render_header
    doc = Nokogiri::HTML(header)

    thead = doc.xpath('.//thead')
    thead.should be_present

    tr = thead.xpath('.//tr')
    tr.should be_present

    th = tr.xpath('.//th')
    th.should be_present

    th.length.should == 3
  end

  it 'creates rows' do
    rows = subject.render_rows
    doc = Nokogiri::HTML(rows)

    tbody = doc.xpath('//tbody')
    tbody.should be_present

    tbody.xpath('.//tr').each_with_index do |row, row_index|
      row.xpath('.//td').each_with_index do |td, td_index|
        object = objects[row_index]
        case td_index
        when 0
          object.id.to_s      == td.text
        when 1
          object.name.should  == td.text
        when 2
          object.email.should == td.text
        end
      end
    end
  end

  it 'creates an entire table' do
    doc = Nokogiri::HTML(subject.render_table)
    table = doc.xpath('//table')
    table.should be_present

    thead = table.xpath('.//thead')
    thead.should be_present

    tbody = table.at_xpath('.//tbody')
    tbody.should be_present

    tbody.xpath('.//tr').length.should == 3
  end

  context 'configuration' do
    before(:all) do
      TableCloth::Configuration.configure do |config|
        config.table.class = 'table'
        config.thead.class = 'thead'
        config.th.class    = 'th'
        config.tbody.class = 'tbody'
        config.tr.class    = 'tr'
        config.td.class    = 'td'
      end
    end

    let(:doc) { Nokogiri::HTML(subject.render_table) }

    it 'tables have a class attached' do
      doc.at_xpath('//table')[:class].should include 'table'
    end

    it 'thead has a class attached' do
      doc.at_xpath('//thead')[:class].should include 'thead'
    end

    it 'th has a class attached' do
      doc.at_xpath('//th')[:class].should include 'th'
    end

    it 'tbody has a class attached' do
      doc.at_xpath('//tbody')[:class].should include 'tbody'
    end

    it 'tr has a class attached' do
      doc.at_xpath('//tr')[:class].should include 'tr'
    end

    it 'td has a class attached' do
      doc.at_xpath('//td')[:class].should include 'td'
    end
  end
end