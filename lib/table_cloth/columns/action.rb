module TableCloth
  module Columns
    class Action < Column
      def value(object, view_context, table)
        actions_html = actions.each_with_object('') do |action, links|
          if action.available?(table)
            links << "\n"
            links << view_context.instance_exec(object, view_context, &action.options[:proc])
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