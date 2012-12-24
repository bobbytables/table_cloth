module TableCloth::Extensions::Actions
  class ActionCollection
    def actions
      @actions ||= []
    end

    def action(options={}, &block)
      actions << Action.new({proc: block}.merge(options))
    end
  end
end