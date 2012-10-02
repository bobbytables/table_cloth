module TableCloth
  module Columns
    class Action < Column
      def value(object, view_context)
        actions_html = actions.inject('') do |links, action|
          href = action.options[:proc].call(object, view_context)
          links + view_context.link_to(action.human_name, href)
        end

        view_context.raw(actions_html)
      end

      def actions
        @actions ||= []
      end
    end
  end
end