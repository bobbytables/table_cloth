FactoryGirl.define do
  factory :action, class: "TableCloth::Extensions::Actions::Action" do
    options({})
    initialize_with { new(options) }
  end
end