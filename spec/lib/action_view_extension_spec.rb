require 'spec_helper'

describe 'Action View Extension' do
  let(:action_view) { ActionView::Base.new }
  let(:objects) do
    3.times.map { FactoryGirl.build(:dummy_model) }
  end

  it 'includes to actionview' do
    action_view.should respond_to :simple_table_for
  end

  it '.simple_table_for renders a table' do
    table = action_view.simple_table_for(objects) do |table|
      table.column :name, :email
    end

    expect(table).to have_tag "table"
  end
end