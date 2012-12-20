module TableCloth
  module Extensions
    module Actions
      autoload :Action, "table_cloth/extensions/actions/action"
      autoload :Column, "table_cloth/extensions/actions/column"
      autoload :ActionCollection, "table_cloth/extensions/actions/action_collection"
      extend ActiveSupport::Concern

      module ClassMethods
        def actions(options={}, &block)
          action_collection.instance_eval(&block)

          column :actions, options.update(collection: action_collection, using: Column)
        end

        private

        def action_collection
          @action_collection ||= ActionCollection.new
        end
      end
    end
  end
end