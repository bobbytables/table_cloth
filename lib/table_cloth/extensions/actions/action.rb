module TableCloth::Extensions::Actions
  class Action
    attr_reader :options

    def initialize(options={})
      @options = options
    end
  end
end