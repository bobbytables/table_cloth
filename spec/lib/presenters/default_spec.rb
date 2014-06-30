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
    let(:thead) { Nokogiri::HTML(subject.thead.to_s) }

    it "creates a thead" do
      expect(thead).to have_tag "thead"
    end

    it "creates th's" do
      expect(thead.css("th").size).to be subject.columns.size
    end

    it "creates th's with the correct text" do
      thead.css("th").each_with_index do |th, i|
        expect(th.text).to eq(subject.columns[i].human_name(view_context))
      end
    end

    it "creates th's with the correct options" do
      thead.at_css("th").attr(:class).should == "th_options_class"
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

    it "creates a row with attributes from row_attributes" do
      tbody = Nokogiri::HTML(subject.tbody.to_s)
      expect(tbody.css('tr:first-child').first.attribute("class").value).to eq("quazimodo-is-awesome")
      expect(tbody.css('tr:first-child').first.attribute("name").value).to eq("What a handsome quazimodo")
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

    context 'html_safe cell content with td_options' do
      let(:objects) do
        list = FactoryGirl.build_list(:dummy_model, 3, :name => nil)
        list.first.name = 'robert'
        list
      end
      let(:dummy_table) { Class.new(DummyTableWithHTMLSafe) }

      it 'only outputs html_safe content in the correct column' do
        tbody = Nokogiri::HTML(subject.tbody.to_s).at_xpath('//tbody')

        expect( tbody.xpath('//td').map(&:content) ).to eq ['robert', '', '']
      end
    end
  end
end
