require 'spec_helper'

describe TableCloth::Configuration do
  subject { Class.new(TableCloth::Configuration) }

  it 'configures default table classes' do
    subject.table_class = 'table'
    subject.table_class.should == 'table'
  end
end