module TableCloth
  class Action
    attr_reader :action, :options
    
    def initialize(action, options)
      @action  = action
      @options = options
    end

    def human_name
      @action.to_s.humanize
    end
  end
end