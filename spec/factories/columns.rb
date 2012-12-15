FactoryGirl.define do
  factory :column, class: "TableCloth::Column" do
    name :name
    options({})

    factory :if_column do
      name :name
      options({ if: :admin? })
    end

    factory :unless_column do
      name :name
      options({ unless: :moderator? })
    end

    initialize_with { new(name, options) }
  end
end