require "spec_helper"

describe TableCloth::Extensions::Actions::Jury do
  let(:action) { FactoryGirl.build(:action, options: action_options) }
  subject { described_class.new(action) }
  let(:model) { double("model") }
  let(:table) { TableCloth::Base.new(nil, nil) }

  context "Proc" do
    context "if .available?" do
      let(:action_options) { {if: Proc.new{|o| o.state == "valid" }} }

      it "returns true for valid models" do
        model.stub state: "valid"
        expect(subject).to be_available(model, table)
      end

      it "returns false for invalid models" do
        model.stub state: "invalid"
        expect(subject).not_to be_available(model, table)
      end
    end

    context "unless .available?" do
      let(:action_options) { {unless: Proc.new{|o| o.state == "invalid" }} }
      
      it "returns true for valid models" do
        model.stub state: "valid"
        expect(subject).to be_available(model, table)
      end

      it "returns false for invalid models" do
        model.stub state: "invalid"
        expect(subject).not_to be_available(model, table)
      end
    end
  end

  context "Symbol" do
    context "if .available?" do
      let(:action_options) { {if: :valid?} }

      it "returns true for valid?" do
        table.stub valid?: true
        expect(subject).to be_available(model, table)
      end

      it "returns true for valid?" do
        table.stub valid?: false
        expect(subject).not_to be_available(model, table)
      end
    end

    context "unless .available?" do
      let(:action_options) { {unless: :valid?} }
      
      it "returns true for valid models" do
        table.stub valid?: false
        expect(subject).to be_available(model, table)
      end

      it "returns false for invalid models" do
        table.stub valid?: true
        expect(subject).not_to be_available(model, table)
      end
    end
  end
end
