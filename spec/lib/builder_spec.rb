require 'spec_helper'

describe TableCloth::Builder do
  subject { Class.new(TableCloth::Builder) }
  let(:view_context) { ActionView::Base.new }

  context '.build' do
    it 'builds a table on the fly with a block' do
      expect {|b| subject.build([], view_context, &b) }.to yield_control
    end

    it 'builds a table from a class name' do
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
      new_table.presenter.should_receive(:render_table).once
      new_table.to_s
    end
  end
end