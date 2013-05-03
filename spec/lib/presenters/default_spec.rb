require 'spec_helper'

describe TableCloth::Presenters::Default do
  let(:dummy_table) { Class.new(DummyTable) }
  let(:dummy_model) { FactoryGirl.build(:dummy_model) }

  let(:objects) do
    FactoryGirl.build_list(:dummy_model, 3)
  end

  let(:view_context) { ActionView::Base.new }
  subject { TableCloth::Presenters::Default.new(objects, dummy_table, view_context) }

  describe "#thead" do
    let(:column_names) { ["Col1", "Col2"] }
    let(:thead) { Nokogiri::HTML(subject.thead.to_s) }

    before(:each) do
      subject.stub column_names: column_names
    end

    it "creates a thead" do
      expect(thead).to have_tag "thead"
    end

    it "creates th's" do
      expect(thead.css("th").size).to be 2
    end

    it "creates th's with the correct text" do
      thead.css("th").each_with_index do |th, i|
        expect(th.text).to eq(column_names[i])
      end
    end
  end

  describe "#render_table" do
    let(:table) { Nokogiri::HTML(subject.render_table.to_s) }

    it "renders a table tag" do
      expect(table).to have_tag "table"
    end
  end

  describe "#tbody" do
    it 'creates a tbody' do
      expect(subject.tbody.to_s).to have_tag "tbody"
    end

    it "creates a row in the tbody" do
      tbody = Nokogiri::HTML(subject.tbody.to_s)
      expect(tbody.css('tr').size).to be 3
    end

    context 'escaped values' do
      let(:objects) do
        FactoryGirl.build_list(:dummy_model, 1,
          name: "<script>alert(\"Im in your columns, snatching your main thread.\")</script>"
        )
      end

      it 'does not allow unescaped values in columns' do
        tbody = Nokogiri::HTML(subject.tbody.to_s).at_xpath('//tbody')

        tbody.xpath('//td').each do |td|
          td.at_xpath('.//script').should_not be_present
        end
      end
    end
  end
end