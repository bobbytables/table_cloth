module TableCloth
  module Columns
    class Action < Column
      def value(object, view_context, table)
        actions_html = actions.inject('') do |links, action|
          if action.available?(table)
            links + "\n" + view_context.capture(object, view_context, &action.options[:proc])
          else
            links
          end
        end

        view_context.raw(actions_html)
      end

      def actions
        @actions ||= []
      end

      def available?(table)
        actions.any? {|a| a.available?(table) }
      end
    end
  end
end