module TableCloth
  class Action
    attr_reader :action, :options
    
    def initialize(action, options)
      @action  = action
      @options = options
    end
  end
end