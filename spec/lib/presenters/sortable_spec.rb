require "spec_helper"

describe TableCloth::Presenters::Sortable do
  let(:dummy_table) { FactoryGirl.build(:dummy_table, name: {sortable: true} ) }
  let(:dummy_model) { FactoryGirl.build(:dummy_model) }
  let(:objects) { FactoryGirl.build_list(:dummy_model, 3) }
  let(:view_context) { ActionView::Base.new }
  subject { TableCloth::Presenters::Sortable.new(objects, dummy_table, view_context) }
  let(:params) { {sort_by: "", direction: "asc"} }
  let(:column) { subject.columns.first }

  before do
    dummy_table.presenter(described_class)
    subject.stub params: params
    column.options[:sortable] = true
  end

  it "inherits from default" do
    expect(described_class).to be < TableCloth::Presenters::Default
  end

  context ".render_sortable" do
    before do
      column.stub human_name: "Header"
    end

    it "renders an a tag" do
      element = to_element(subject.render_sortable(column), "a")
      expect(element.node_name).to eq("a")
    end

    it "renders an a tag with href direction keys" do
      params[:direction] = "desc"
      element = to_element(subject.render_sortable(column), "a")
      query_string = element[:href]

      expect(query_string).to include "direction=asc"
    end

    it "renders an a tag with href sort by keys" do
      params[:sort_by] = "desc"
      element = to_element(subject.render_sortable(column), "a")
      query_string = element[:href]

      expect(query_string).to include "sort_by=#{column.name}"
    end
  end

  context "thead" do
    it "includes a css class for a sortable column" do
      header = to_element(subject.render_header, "thead")
      expect(header.at_css("th.sortable-column")).to be_present
    end
  end
end