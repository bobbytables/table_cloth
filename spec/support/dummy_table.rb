class DummyTable < TableCloth::Base
  column :id
  column :name
  column :email
end

class DummyTableUnlessAdmin < TableCloth::Base
  column :id, unless: :admin?
  column :name
  column :email  
end