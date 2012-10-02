module TableCloth
  class Action
    attr_reader :action, :options
    
    def initialize(options)
      @options = options
    end
  end
end