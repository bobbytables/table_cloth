module TableCloth::Extensions::Actions
  class ActionCollection
    def actions
      @actions ||= []
    end

    def action(&block)
      actions << Action.new(proc: block)
    end
  end
end