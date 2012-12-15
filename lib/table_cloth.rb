require 'action_view'
require 'active_support/core_ext/class'
require 'table_cloth/version'
require 'table_cloth/configurable_elements'
require 'table_cloth/base'

module TableCloth
  autoload :Configuration, 'table_cloth/configuration'
  autoload :Builder, 'table_cloth/builder'
  autoload :Column, 'table_cloth/column'
  autoload :Presenter, 'table_cloth/presenter'
  autoload :ActionViewExtension, 'table_cloth/action_view_extension'

  module Presenters
    autoload :Default, 'table_cloth/presenters/default'
  end

  def config_for(type)
    Configuration.config_for(type).dup
  end
  module_function :config_for
end

TableCloth::Base.presenter ::TableCloth::Presenters::Default

ActionView::Base.send(:include, TableCloth::ActionViewExtension)