module TableCloth
  class Configuration
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

    class << self
      def configure(&block)
        block.arity > 0 ? block.call(self) : yield
      end

      def config_for(type)
        self.send(type).to_hash
      end
    end
  end
end