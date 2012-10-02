module TableCloth
  module ActionViewExtension
    def simple_table_for(objects, options={}, &block)
      view_context = self
      table = if block_given?
        TableCloth::Builder.build(objects, view_context, options) do |table|
          yield table
        end
      else
        TableCloth::Builder.build(objects, view_context, options)
      end

      table.to_s
    end
  end
end