module TableCloth::Extensions::Actions
  class Column < ::TableCloth::Column
    def value(object, view, table=nil)
      actions = action_collection.actions.map do |action|
        action.value(object, view, table)
      end

      view.raw(actions.join(separator))
    end

    private

    def separator
      options[:separator] || " "
    end

    def action_collection
      @action_collection ||= options[:collection]
    end
  end
end
