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
          body = rows.inject('') do |r, values|
            r + render_row(values)
          end

          v.raw(body)
        end
      end

      def render_row(values)
        wrapper_tag :tr do
          row = values.inject('') do |tds, value|
            tds + wrapper_tag(:td, value)
          end

          v.raw(row)
        end
      end

      def render_header
        wrapper_tag :thead do
          wrapper_tag(:tr) do
            names = column_names.inject('') do |tags, name|
              tags + wrapper_tag(:th, name)
            end

            v.raw(names)
          end
        end
      end
    end
  end
end