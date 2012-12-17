FactoryGirl.define do
  factory :dummy_table, class: "TableCloth::Base" do
    initialize_with do
      Class.new(TableCloth::Base).tap do |klass|
        attributes.each do |key,attribute|
          klass.column *[key, attribute]
        end
      end
    end
  end
end