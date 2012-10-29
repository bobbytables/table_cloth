class <%= class_name %>Table < TableCloth::Base
  # Define columns with the #column method
  # column :name, :email

  # Columns can be provided a block
  #
  # column :name do |object|
  #   object.downcase
  # end
  #
  # Columns can also have conditionals if you want.
  # The conditions are checked against the table's methods.
  # As a convience, the table has a #view method which will return the current view context.
  # This gives you access to current user, params, etc...
  #
  # column :email, if: :admin?
  #
  # def admin?
  #   view.current_user.admin?
  # end
  #
  # Actions give you the ability to create a column for any actions you'd like to provide.
  # Pass a block with an arity of 2, (object, view context).
  # You can add as many actions as you want.
  #
  # action {|object, view| view.link_to "Edit", view.edit_object_path(object) }
end
