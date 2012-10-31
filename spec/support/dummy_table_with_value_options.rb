class DummyTableWithValueOptions < TableCloth::Base
  column :email do
    ["robert@creativequeries.com", {class: "special-class"}]
  end
end