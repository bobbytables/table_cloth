require "spec_helper"

describe TableCloth::ColumnJury do
  let(:dummy_table) { double(:table, admin?: true, moderator?: false) }

  subject { TableCloth::ColumnJury.new(column, dummy_table) }

  context 'conditions' do
    context 'if' do
      let(:column) { FactoryGirl.build(:if_column) }

      specify 'the column is available when condition returns true' do
        expect(subject).to be_available
      end

      it 'the column is not available when condition returns false' do
        dummy_table.stub admin?: false
        expect(subject).not_to be_available
      end
    end

    context 'unless' do
      let(:column) { FactoryGirl.build(:unless_column) }

      specify 'the column is available when condition returns false' do
        expect(subject).to be_available
      end

      specify 'the column is not available when condition returns true' do
        dummy_table.stub moderator?: true
        expect(subject).not_to be_available
      end
    end
  end
end
