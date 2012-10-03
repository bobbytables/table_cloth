require 'spec_helper'

describe TableCloth::Columns::Action do
  let(:view_context) { ActionView::Base.new }
  let(:dummy_table) { Class.new(DummyTable) }
  let(:dummy_model) do
    DummyModel.new.tap do |d|
      d.id    = 1
      d.email = 'robert@example.com'
      d.name  = 'robert'
    end
  end

  subject { TableCloth::Columns::Action.new(object, view_context) }

  it '.value returns all actions in HTML' do
    dummy_table.action {|object, view| view.link_to "Edit", "#{object.id}"}
    presenter = TableCloth::Presenters::Default.new([dummy_model], dummy_table, view_context)

    doc = Nokogiri::HTML(presenter.render_table)

    actions_column = doc.at_xpath('//tbody')
      .at_xpath('.//tr')
      .xpath('.//td')
      .last

    link = actions_column.at_xpath('.//a')
    link.should be_present
    link[:href].should == '1'
  end

  it '.value only returns actions that pass' do
    admin_action     = dummy_table.action(if: :admin?) { '/admin' }
    moderator_action = dummy_table.action(if: :moderator?) { '/moderator' }
    table            = dummy_table.new([], view_context)

    def table.admin?
      true
    end

    def table.moderator?
      false
    end

    dummy_table.columns[:actions].value(dummy_model, view_context, table).should include '/admin'
    dummy_table.columns[:actions].value(dummy_model, view_context, table).should_not include '/moderator'
  end
end