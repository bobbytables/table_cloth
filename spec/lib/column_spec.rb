require 'spec_helper'

describe TableCloth::Column do
  subject { Class.new(TableCloth::Column) }
  let(:view_context) { ActionView::Base.new }
  let(:dummy_model) { FactoryGirl.build(:dummy_model) }

  context 'values' do
    let(:proc) do
      lambda {|object, view| object.email.gsub("@", " at ")}
    end

    let(:name_column) { TableCloth::Column.new(:name) }
    let(:email_column) { TableCloth::Column.new(:my_email, proc: proc) }

    it 'returns the name correctly' do
      name_column.value(dummy_model, view_context).should == 'robert'
    end

    it 'returns the email from a proc correctly' do
      email_column.value(dummy_model, view_context).should == 'robert at example.com'
    end
  end

  context "human name" do
    it "returns the label when set" do
      column = FactoryGirl.build(:column, options: { label: "Whatever" })
      expect(column.human_name(view_context)).to eq("Whatever")
    end

    it "humanizes the symbol if no label is set" do
      column = FactoryGirl.build(:column, name: :email)
      expect(column.human_name(view_context)).to eq("Email")
    end

    it "runs with a proc" do
      column = FactoryGirl.build(:column, options: { label: Proc.new{ tag :span }} )
      expect(column.human_name(view_context)).to eq("<span />")
    end
  end
end