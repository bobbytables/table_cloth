require 'spec_helper'

describe TableCloth::Presenter do
  subject { TableCloth::Presenter.new(objects, dummy_table, view_context) }
  let(:dummy_table) { Class.new(DummyTable) }
  let(:dummy_model) { FactoryGirl.build(:dummy_model) }

  let(:objects) { 3.times.map { FactoryGirl.build(:dummy_model) } }

  let(:view_context) { ActionView::Base.new }
  subject { TableCloth::Presenter.new(objects, dummy_table, view_context) }

  context ".columns" do
    it "returns all columns from the table" do
      expect(subject).to have(3).columns
    end

    it "returns them as columns" do
      subject.columns.each do |column|
        expect(column).to be_kind_of TableCloth::Column
      end
    end

    context "that are unavaialble" do
      let(:dummy_table) { FactoryGirl.build(:dummy_table, email: {if: :admin?}) }
      let(:table_instance) { dummy_table.new(objects, view_context) }
      before(:each) do 
        table_instance.stub admin?: false
        subject.stub table: table_instance
      end

      specify "are not returned" do
        expect(subject).to have(0).columns
      end

      specify "name is not returned" do
        expect(subject.column_names).not_to include "email"
      end
    end
  end

  context ".column_names" do
    let(:table_instance) { dummy_table.new(objects, view_context) }
    before(:each) { table_instance.stub admin?: false, awesome?: true }

    it 'returns all names' do
      subject.column_names.should == ["Id", "Name", "Email"]
    end
  end

  it 'returns all values for a row' do
    subject.row_values(dummy_model).should == [dummy_model.id, dummy_model.name, dummy_model.email]
  end
  
  it 'generates the values for all of the rows' do
    expected = objects.map {|o| [o.id, o.name, o.email] }
    expect(subject.rows).to eq(expected)
  end

  context '.wrapper_tag' do
    it "creates a tag with a block" do
      table = subject.wrapper_tag(:table) { "Hello" }
      element = to_element(table, "table")
      expect(element).to be_present
      expect(element.text).to eq("Hello")
    end

    it "creates a tag without a block" do
      table = subject.wrapper_tag(:table, "Hello")
      element = to_element(table, "table")
      expect(element).to be_present
      expect(element.text).to eq("Hello")
    end

    context "config" do
      let(:config) { double("config", config_for: { class: "table_class" }) }

      it "inherits options from global config" do
        TableCloth.config.stub config_for: {class: "global_class"}
        tag = subject.wrapper_tag(:table, "Hello")
        element = to_element(tag, "table")

        expect(element[:class]).to eq("global_class")
      end

      it "includes config sent to it" do
        tag = subject.wrapper_tag(:table, "Hello", {class: "passed_class"})
        element = to_element(tag, "table")

        expect(element[:class]).to eq("passed_class")
      end

      it "includes config from the table instance" do
        dummy_table.stub config: config
        tag = subject.wrapper_tag(:table, "Hello", {class: "passed_class"})
        element = to_element(tag, "table")

        expect(element[:class]).to eq("table_class")
      end
    end
  end
end