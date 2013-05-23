module TableCloth
  module Presenters
    class Default < ::TableCloth::Presenter
      def render_table
        @render_table ||= ElementFactory::Element.new(:table, tag_options(:table)).tap do |table|
          table << thead
          table << tbody
        end
      end

      def thead
        @thead ||= ElementFactory::Element.new(:thead, tag_options(:thead)).tap do |thead|
          thead << thead_row
        end
      end

      def tbody
        @tbody ||= ElementFactory::Element.new(:tbody, tag_options(:tbody)).tap do |tbody|
          objects.each {|object| tbody << row_for_object(object) }
        end
      end

      private

      def thead_row
        @thead_row ||= ElementFactory::Element.new(:tr, tag_options(:tr)).tap do |row|
          column_names.each do |name|
            row << ElementFactory::Element.new(:th, tag_options(:th).merge(text: name))
          end
        end
      end

      def row_for_object(object)
        ElementFactory::Element.new(:tr, tag_options(:tr)).tap do |row|
          columns.each do |column|
            row << column_for_object(column, object)
          end
        end
      end

      def column_for_object(column, object)
        td_options = column.options[:td_options] || {}
        value = column.value(object, view_context, table)

        if value.is_a?(Array)
          options = value.pop
          value   = value.shift

          td_options.update(options)
        end

        if value.html_safe?
          td_options[:inner_html] = value
        else
          td_options[:text] = value
        end

        ElementFactory::Element.new(:td, tag_options(:td).merge(td_options))
      end
    end
  end
end