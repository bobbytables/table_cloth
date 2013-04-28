module TableCloth
  class Configuration
    ELEMENT_OPTIONS = %w(table thead th tbody tr td).map(&:to_sym)

    GENERAL_OPTIONS = %w(alternating_rows).map(&:to_sym)
    attr_accessor *GENERAL_OPTIONS

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
      value = send(type)
      value.respond_to?(:to_hash) ? value.to_hash : value
    end
    alias [] config_for
  end
end