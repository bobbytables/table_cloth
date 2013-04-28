module TableCloth
  class Configuration
    ELEMENT_OPTIONS = %w(table thead th tbody tr td).map(&:to_sym)

    ELEMENT_OPTIONS.each do |option|
      class_eval <<-OPTION, __FILE__, __LINE__+1
        def #{option}
          @#{option}_option ||= ActiveSupport::OrderedOptions.new
        end
      OPTION
    end

    class << self
      def configure(&block)
        yield TableCloth.config
      end
    end

    def config_for(type)
      send(type).to_hash
    end
    alias [] config_for
  end
end