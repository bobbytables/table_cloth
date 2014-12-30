require 'spec_helper'

describe TableCloth::Base do
  subject { Class.new(TableCloth::Base) }
  let(:view_context) { ActionView::Base.new }
  let(:dummy_model) { FactoryGirl.build(:dummy_model) }
  let(:table_instance) { subject.new([], view_context) }

  context 'columns' do
    it 'has a column method' do
      expect(subject).to respond_to :column
    end

    it 'column accepts a name' do
      expect { subject.column :column_name }.not_to raise_error
    end

    it 'column accepts options' do
      subject.column :name, option: "value"
      expect(subject.columns[:name][:options][:option]).to eq("value")
    end

    it '.columns returns all columns' do
      subject.column :name
      expect(subject).to have(1).columns
    end

    it 'accepts multiple column names' do
      subject.column :name, :email
      expect(subject).to have(2).columns
    end

    it 'stores a proc if given in options' do
      subject.column(:name) { 'Wee' }

      column = subject.columns[:name]
      expect(column[:options][:proc]).to be_present
      expect(column[:options][:proc]).to be_kind_of(Proc)
    end

    context "custom" do
      let(:custom_column) { double(:custom, value: "AN EMAIL") }

      it '.column can take a custom column' do
        subject.column :email, using: custom_column
        expect(subject.columns[:email][:class]).to eq(custom_column)
      end
    end
  end

  context ".config" do
    it "returns a configurable class" do
      expect(subject.config).to be_kind_of TableCloth::Configuration
    end

    context "for an instance" do
      it "returns a configurable class" do
        expect(table_instance.config).to be_kind_of TableCloth::Configuration
      end
    end

    context "inheritance" do
      let(:parent_class) { Class.new(TableCloth::Base) }
      let(:child_class) { Class.new(parent_class) }

      before { parent_class.config.table.class = "inherit-me" }

      it "inherits from a parent class's configuration" do
        expect(child_class.config.table[:class]).to eq "inherit-me"
      end
    end
  end

  context 'presenters' do
    it 'has a presenter method' do
      subject.should respond_to :presenter
    end
  end

  context "configuration" do
    subject { Class.new(TableCloth::Base) }
    let(:sibling1_class) { Class.new(subject) }
    let(:sibling2_class) { Class.new(subject) }

    it "allows configuration" do
      expect { subject.config.table.cellpadding = '0' }.to change { subject.config.table.cellpadding }.to('0')
    end

    it "doesn't interfere with configuration of parent classes" do
      expect { sibling1_class.config.table.cellpadding = '0' }.not_to change { sibling2_class.config.table.cellpadding }
    end
  end

  describe '.actions' do
    it 'exists in class' do
      expect(subject).to respond_to(:actions)
    end
  end
end
