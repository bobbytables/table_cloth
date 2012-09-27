module TableCloth
  class Column
    attr_reader :options, :name

    def initialize(name, options={})
      @name    = name
      @options = options
    end

    def value(object)
      if options[:if] && options[:if].is_a?(Symbol)
        return '' unless !!object.send(options[:if])
      end

      if options[:unless] && options[:unless].is_a?(Symbol)
        return '' if !!object.send(options[:unless])
      end

      if options[:proc] && options[:proc].respond_to?(:call)
        options[:proc].call(object, options)
      else
        object.send(name)
      end
    end
  end
end