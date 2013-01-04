require "action_view"
require "active_support/core_ext/class"
require "table_cloth/version"
require "table_cloth/configurable_elements"

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
  end

  module Extensions
    autoload :Actions, "table_cloth/extensions/actions"
  end

  class << self
    def config
      @config ||= Configuration.new
    end
  end
end

TableCloth::Base.presenter ::TableCloth::Presenters::Default

ActionView::Base.send(:include, TableCloth::ActionViewExtension)