class DummyTable < TableCloth::Base
  row_attributes name: "What a handsome quazimodo" do |obj|
    {class: "quazimodo-is-awesome"} if obj.present?
  end
  column :id, th_options: {class: "th_options_class"}
  column :name
  column :email
end

class DummyTableUnlessAdmin < TableCloth::Base
  column :id, unless: :admin?
  column :name
  column :email
end
