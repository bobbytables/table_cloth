module TableCloth
  module Columns
    class Action < Column
      def value(object, view_context)
        actions_html = actions.inject('') do |links, action|
          links + view_context.capture(object, view_context, &action.options[:proc])
        end

        view_context.raw(actions_html)
      end

      def actions
        @actions ||= []
      end
    end
  end
end