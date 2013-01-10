module TableCloth
  module Presenters
    class Sortable < Default
      def render_header
        wrapper_tag :thead do
          wrapper_tag :tr, v.raw(row_headers.join("\n"))
        end
      end

      def render_sortable(column)
        query_string = sort_query(sort_params_for(column))
        wrapper_tag(:a, column.human_name, href: "?#{query_string}")
      end

      def row_headers
        columns.map do |column|
          if !!column.options[:sortable]
            wrapper_tag :th, render_sortable(column), class: "sortable-column"
          else
            column.human_name
          end
        end
      end

      private

      def sort_params_for(column)
        direction = params[:direction]
        new_direction = (direction == "asc") ? "desc" : "asc"

        params.update({sort_by: column.name.to_s, direction: new_direction})
      end

      def sort_query(params)
        params.stringify_keys.map{|k,v| "#{CGI.escape(k)}=#{CGI.escape(v)}" }.join("&")
      end

      def header_values
        columns.map do |column|
          if !!column.options[:sortable]
            render_sortable(column)
          else
            column.human_name
          end
        end
      end
    end
  end
end