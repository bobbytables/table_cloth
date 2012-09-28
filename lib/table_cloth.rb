require 'action_view'
require 'table_cloth/version'
require 'table_cloth/base'

module TableCloth
  autoload :Configuration, 'table_cloth/configuration'
  autoload :Column, 'table_cloth/column'
  autoload :Action, 'table_cloth/action'
  autoload :Presenter, 'table_cloth/presenter'

  module Presenters
    autoload :Default, 'table_cloth/presenters/default'
  end

  module Columns
    autoload :Action, 'table_cloth/columns/action'
  end
end

TableCloth::Base.presenter ::TableCloth::Presenters::Default