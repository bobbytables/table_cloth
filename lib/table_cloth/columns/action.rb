module TableCloth
  module Columns
    class Action < Column
      def value(object, view_context)
        actions.inject('') do |links, action|
          href = view_context.instance_eval(&action.options[:proc])
          links + view_context.link_to(action.human_name, href)
        end
      end

      def actions
        @actions ||= []
      end
    end
  end
end