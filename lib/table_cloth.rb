require "action_view"
require "element_factory"
require "active_support/core_ext/class"
require "table_cloth/version"

module TableCloth
  autoload :Base, "table_cloth/base"
  autoload :Configuration, "table_cloth/configuration"
  autoload :Builder, "table_cloth/builder"
  autoload :Column, "table_cloth/column"
  autoload :ColumnJury, "table_cloth/column_jury"
  autoload :Presenter, "table_cloth/presenter"
  autoload :ActionViewExtension, "table_cloth/action_view_extension"

  module Presenters
    autoload :Default, "table_cloth/presenters/default"
    autoload :Sortable, "table_cloth/presenters/sortable"
  end

  module Extensions
    autoload :Actions, "table_cloth/extensions/actions"
    autoload :RowAttributes, "table_cloth/extensions/row_attributes"
  end

  class << self
    def config
      @config ||= Configuration.new
    end
  end
end

# Set the default presenter
TableCloth::Base.presenter(TableCloth::Presenters::Default)

ActiveSupport.on_load(:action_view) do
  include TableCloth::ActionViewExtension
end
