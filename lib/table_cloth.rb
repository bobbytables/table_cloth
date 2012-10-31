require 'action_view'
require 'table_cloth/version'
require 'table_cloth/configurable_elements'
require 'table_cloth/base'

module TableCloth
  autoload :Configuration, 'table_cloth/configuration'
  autoload :Builder, 'table_cloth/builder'
  autoload :Column, 'table_cloth/column'
  autoload :Action, 'table_cloth/action'
  autoload :Actions, 'table_cloth/actions'
  autoload :Presenter, 'table_cloth/presenter'
  autoload :ActionViewExtension, 'table_cloth/action_view_extension'

  module Presenters
    autoload :Default, 'table_cloth/presenters/default'
  end

  module Columns
    autoload :Action, 'table_cloth/columns/action'
  end

  def config_for(type)
    Configuration.config_for(type)
  end
  module_function :config_for
end

TableCloth::Base.presenter ::TableCloth::Presenters::Default

ActionView::Base.send(:include, TableCloth::ActionViewExtension)