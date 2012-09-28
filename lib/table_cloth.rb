require 'action_view'
require 'table_cloth/version'

module TableCloth
  autoload :Configuration, 'table_cloth/configuration'
  autoload :Base, 'table_cloth/base'
  autoload :Column, 'table_cloth/column'
  autoload :Presenter, 'table_cloth/presenter'

  module Presenters
    autoload :Default, 'table_cloth/presenters/default'
  end
end