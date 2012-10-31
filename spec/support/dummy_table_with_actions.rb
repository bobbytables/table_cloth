class DummyTableWithActions < TableCloth::Base
  column :name

  actions(td_options: {class: 'actions'}) do
    action {|object| link_to "Edit", "/#{object.id}/edit" }
  end
end