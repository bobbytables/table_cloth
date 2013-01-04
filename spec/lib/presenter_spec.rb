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

  context 'tags' do
    it '.wrapper_tag includes config for a tag in block form' do
      TableCloth::Configuration.table.should_receive(:to_hash).once.and_return(class: "stuff")
      table = subject.wrapper_tag(:table) { "Hello "}
      Nokogiri::HTML(table).at_xpath('//table')[:class].should == 'stuff'
    end

    it '.wrapper_tag includes config for a tag without a block' do
      TableCloth::Configuration.table.should_receive(:to_hash).once.and_return(class: "stuff")
      table = subject.wrapper_tag(:table, 'Hello')
      Nokogiri::HTML(table).at_xpath('//table')[:class].should == 'stuff'
    end
  end
end