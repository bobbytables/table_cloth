# Table Cloth

Table Cloth gives you an easy to use DSL for creating and rendering tables in rails.

[![Build Status](https://travis-ci.org/bobbytables/table_cloth.png)](https://travis-ci.org/bobbytables/table_cloth)

## Installation

Add this line to your application's Gemfile:

    gem 'table_cloth'

And then execute:

    $ bundle

## Usage

Table Cloth can use defined tables in app/tables or you can build them on the fly.

Table models can be generated using rails generators.

```
$ rails g table User
```

It will make this:

```
class UserTable < TableCloth::Base
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
  # action {|object, view| view.link_to "Edit", edit_object_path(object) }
end
```

Go ahead and modify it to suit your needs, pick the columns, conditions, actions, etc...

In your view, you would then use this code:
```
<%= simple_table_for @users, with: UserTable %>

```

The second approach to making tables with Table Cloth is in the view.

```
<%= simple_table_for @users do |t| %>
  <% t.column :name %>
  <% t.column :email %>
  <% t.action {|user| link_to "View", user %>
<% end %>
```

## Configuration

Create an initializer called ```table_cloth.rb```

Configuration looks like this:

```ruby
TableCloth::Configuration.configure do |config|
  config.table.class = 'table table-bordered'
  config.thead.class = ''
  config.tbody.class = ''
  config.tr.class =''
  config.th.class =''
  config.td.class =''
end
```

You can set any value on table element configurations. For example:

```ruby
config.table.cellpadding = 1
config.td.valign = 'top'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. CREATE A SPEC.
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
