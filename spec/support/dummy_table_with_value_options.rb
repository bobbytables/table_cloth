class DummyTableWithValueOptions < TableCloth::Base
  column :email do
    ["robert@example.com", {class: "special-class"}]
  end
end