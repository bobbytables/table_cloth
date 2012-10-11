module TableCloth
  module ConfigurableElements
    extend ActiveSupport::Concern

    included do
      cattr_accessor :table
      cattr_accessor :thead
      cattr_accessor :th
      cattr_accessor :tbody
      cattr_accessor :tr
      cattr_accessor :td

      self.table = ActiveSupport::OrderedOptions.new
      self.thead = ActiveSupport::OrderedOptions.new
      self.th    = ActiveSupport::OrderedOptions.new
      self.tbody = ActiveSupport::OrderedOptions.new
      self.tr    = ActiveSupport::OrderedOptions.new
      self.td    = ActiveSupport::OrderedOptions.new
    end
  end
end