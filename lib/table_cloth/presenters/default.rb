module TableCloth
  module Presenters
    class Default < ::TableCloth::Presenter
      def render_table
        wrapper_tag :table do
          render_header + render_rows
        end
      end

      def render_rows
        wrapper_tag :tbody do
          v.raw objects.inject('') {|r, object| r + render_row(object) }
        end
      end

      def render_row(object)
        wrapper_tag :tr do
          v.raw table.columns.inject('') {|tds, (key, column)| tds + render_td(column, object) }
        end
      end

      def render_td(column, object)
        td_options = column.options[:td_options] || {}
        value = column.value(object, view_context, table)

        if value.is_a?(Array)
          options = value.pop
          value   = value.shift

          td_options.update(options)
        end

        wrapper_tag(:td, value, td_options)
      end

      def render_header
        wrapper_tag :thead do
          wrapper_tag :tr do
            v.raw column_names.inject('') {|tags, name| tags + wrapper_tag(:th, name) }
          end
        end
      end
    end
  end
end