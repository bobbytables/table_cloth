class DummyTable < TableCloth::Base
  column :id, th_options: {class: "th_options_class"}
  column :name
  column :email
end

class DummyTableUnlessAdmin < TableCloth::Base
  column :id, unless: :admin?
  column :name
  column :email  
end