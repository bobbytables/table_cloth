module TableCloth
  module Presenters
    class Default < ::TableCloth::Presenter
      def render_table
        v.content_tag :table do
          render_header + render_rows
        end
      end

      def render_rows
        v.content_tag :tbody do
          body = rows.inject('') do |r, values|
            r + render_row(values)
          end

          v.raw(body)
        end
      end

      def render_row(values)
        v.content_tag :tr do
          row = values.inject('') do |tds, value|
            tds + v.content_tag(:td, value)
          end

          v.raw(row)
        end
      end

      def render_header
        v.content_tag :thead do
          v.content_tag :tr do
            names = column_names.inject('') do |tags, name|
              tags + v.content_tag(:th, name)
            end

            v.raw(names)
          end
        end
      end
    end
  end
end