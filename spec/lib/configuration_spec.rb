require 'spec_helper'

describe TableCloth::Configuration do
  subject { Class.new(TableCloth::Configuration) }

  it 'configures table options' do
    subject.table.classes = 'table'
    subject.table.classes.should == 'table'
  end

  it 'configures thead options' do
    subject.thead.classes = 'thead'
    subject.thead.classes.should == 'thead'
  end

  it 'configures th options' do
    subject.th.classes = 'th'
    subject.th.classes.should == 'th'
  end

  it 'configures tbody options' do
    subject.tbody.classes = 'tbody'
    subject.tbody.classes.should == 'tbody'
  end

  it 'configures tr options' do
    subject.tr.classes = 'tr'
    subject.tr.classes.should == 'tr'
  end

  it 'configures td options' do
    subject.td.classes = 'td'
    subject.td.classes.should == 'td'
  end
end