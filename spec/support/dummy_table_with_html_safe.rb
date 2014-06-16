class DummyTableWithHTMLSafe < TableCloth::Base
  column :name, td_options: { class: 'irrelevant' } do |object|
    object.name.html_safe if object.name
  end
end