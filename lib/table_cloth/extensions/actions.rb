module TableCloth
  module Extensions
    module Actions
      autoload :Action, "table_cloth/extensions/actions/action"
      autoload :Column, "table_cloth/extensions/actions/column"
      autoload :ActionCollection, "table_cloth/extensions/actions/action_collection"
      autoload :Jury, "table_cloth/extensions/actions/jury"
      extend ActiveSupport::Concern

      module ClassMethods
        def actions(options={}, &block)
          action_collection.instance_eval(&block)

          column :actions, options.update(collection: action_collection, using: Column)
        end

        private

        def action_collection
          @action_collection ||= if superclass.respond_to? :action_collection
            superclass.action_collection.dup
          else
            ActionCollection.new
          end
        end
      end
    end
  end
end