module TableCloth
  class Action
    attr_reader :action, :options
    
    def initialize(options)
      @options = options
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