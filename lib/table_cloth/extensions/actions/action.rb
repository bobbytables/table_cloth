module TableCloth::Extensions::Actions
  class Action
    attr_reader :options

    def initialize(options={})
      @options = options
    end

    def jury
      @jury ||= Jury.new(self)
    end
  end
end