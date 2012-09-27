class DummyModel < Struct.new(:name, :email, :admin, :id)
  def admin?
    !!admin
  end
end