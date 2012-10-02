require 'spec_helper'

describe TableCloth::Builder do
  subject { Class.new(TableCloth::Builder) }
  let(:view_context) { ActionView::Base.new }

  context '.build' do
    it 'can build a table on the fly with a block' do
      new_table = subject.build([], view_context) do |table|
        table.column :name
        table.action(:edit) { '/model/1/edit' }
      end

      new_table.table.columns.length.should == 2
      new_table.table.columns[:actions].actions.length.should == 1
    end

    it 'can build a table from a class name' do
      new_table = subject.build([], view_context, with: DummyTable)
      new_table.table.should == DummyTable
    end

    it 'defaults the presenter' do
      new_table = subject.build([], view_context, with: DummyTable)
      new_table.presenter.should be_kind_of TableCloth::Presenters::Default
    end

    it 'can provide a presenter' do
      random_presenter = Class.new(TableCloth::Presenters::Default)
      new_table        = subject.build([], view_context, with: DummyTable, present_with: random_presenter)
      new_table.presenter.should be_kind_of random_presenter
    end

    it '.to_s renders a table' do
      new_table = subject.build([], view_context, with: DummyTable)
      body      = new_table.to_s
      doc       = Nokogiri::HTML(body)
      doc.at_xpath('//table').should be_present
    end
  end
end