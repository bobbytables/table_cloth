require 'spec_helper'

describe TableCloth::Presenters::Default do
  let(:dummy_table) { Class.new(DummyTable) }
  let(:dummy_model) { FactoryGirl.build(:dummy_model) }

  let(:objects) do
    FactoryGirl.build_list(:dummy_model, 3)
  end

  let(:view_context) { ActionView::Base.new }
  subject { TableCloth::Presenters::Default.new(objects, dummy_table, view_context) }

  context "header" do
    let(:column_names) { ["Col1", "Col2"] }

    before(:each) do
      subject.stub column_names: column_names
    end

    it "creates a thead" do
      expect(subject.render_header).to have_tag "thead"
    end

    it "creates th's" do
      header = Nokogiri::HTML(subject.render_header)
      expect(header.css("th").size).to be 2
    end

    it "creates th's with the correct text" do
      header = Nokogiri::HTML(subject.render_header)
      header.css("th").each_with_index {|th, i| expect(th.text).to eq(column_names[i]) }
    end
  end

  context "rows" do
    it 'creates a tbody' do
      expect(subject.render_rows).to have_tag "tbody"
    end

    it "creates a row in the tbody" do
      tbody = Nokogiri::HTML(subject.render_rows)
      expect(tbody.css('tr').size).to be 3
    end
  end

  context 'escaped values' do
    let(:objects) do
      FactoryGirl.build_list(:dummy_model, 1, 
        name: "<script>alert(\"Im in your columns, snatching your main thread.\")</script>"
      )
    end

    it 'does not allow unescaped values in columns' do
      tbody = Nokogiri::HTML(subject.render_rows).at_xpath('//tbody')

      tbody.xpath('//td').each do |td|
        td.at_xpath('.//script').should_not be_present
      end
    end
  end

  context "column configuration" do
    let(:column) { FactoryGirl.build(:column, options: {td_options: {class: "email_column"}}) }
    let(:model) { FactoryGirl.build(:dummy_model) }

    it "td has a class set" do
      td = Nokogiri::HTML(subject.render_td(column, model)).at_css("td")
      expect(td[:class]).to eq "email_column"
    end

    context "by value of row column" do
      before(:each) do
        column.stub value: ["robert@example.com", {class: "special-class"}]
      end

      specify "column has options because of value" do
        td = Nokogiri::HTML(subject.render_td(column, model)).at_css("td")

        expect(td.text).to include "robert@example.com"
        expect(td[:class]).to eq("special-class")
      end
    end
  end
end