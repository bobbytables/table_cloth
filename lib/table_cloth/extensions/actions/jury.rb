module TableCloth::Extensions::Actions
  class Jury
    attr_reader :action

    def initialize(action)
      @action = action
    end

    def available?(object)
      case action_if
      when Proc
        return !!action_if.call(object)
      when Symbol
        return !!object.send(action_if)
      end

      case action_unless
      when Proc
        return !action_unless.call(object)
      when Symbol
        return !object.send(action_unless)
      end
    end

    private

    def action_if
      action.options[:if]
    end

    def action_unless
      action.options[:unless]
    end
  end
end