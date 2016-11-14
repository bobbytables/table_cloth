module TableCloth
  module Presenters
    class Default < ::TableCloth::Presenter
      def render_table
        @render_table ||= ElementFactory::Element.new(:table, tag_options(:table)).tap do |table|
          table << thead
          table << tbody
        end.to_html
      end

      def thead
        @thead ||= ElementFactory::Element.new(:thead, tag_options(:thead)).tap do |thead|
          thead << thead_row
        end
      end

      def tbody
        @tbody ||= ElementFactory::Element.new(:tbody, tag_options(:tbody)).tap do |tbody|
          objects.each {|object| tbody << row_for_object(object, view_context) }
        end
      end

      private

      def thead_row
        @thead_row ||= ElementFactory::Element.new(:tr, tag_options(:tr)).tap do |row|
          columns.each do |column|
            th_options = column.options[:th_options] || {}
            name = column.human_name(view_context)
            row << ElementFactory::Element.new(:th, tag_options(:th, th_options).merge(text: name))
          end
        end
      end

      def row_for_object(object, view_context)
        tr_options = table.class.tr_options_for(object, view_context)

        ElementFactory::Element.new(:tr, tag_options(:tr).merge(tr_options)).tap do |row|
          columns.each do |column|
            row << column_for_object(column, object)
          end
        end
      end

      def column_for_object(column, object)
        td_options = column.options[:td_options].try(:dup) || {}
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
