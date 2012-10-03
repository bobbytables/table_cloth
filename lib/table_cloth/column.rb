module TableCloth
  class Column
    attr_reader :options, :name

    def initialize(name, options={})
      @name    = name
      @options = options
    end

    def value(object, view, table=nil)
      if options[:proc] && options[:proc].respond_to?(:call)
        view.capture(object, options, view, &options[:proc])
      else
        object.send(name)
      end
    end

    def human_name
      options[:label] || name.to_s.humanize
    end

    def available?(table)
      if options[:if] && options[:if].is_a?(Symbol)
        return !!table.send(options[:if])
      end

      if options[:unless] && options[:unless].is_a?(Symbol)
        return !table.send(options[:unless])
      end

      true
    end
  end
end