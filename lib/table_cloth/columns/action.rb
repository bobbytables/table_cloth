module TableCloth
  module Columns
    class Action < Column
      def value(object, view_context)
        options[:actions].inject('') do |links, (key, action)|
          href = view_context.instance_eval(&action[:proc])
          links + view_context.link_to(key.to_s.humanize, href)
        end
      end
    end
  end
end