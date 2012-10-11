module TableCloth
  class Presenter
    attr_reader :view_context, :table_definition, :objects,
      :table

    def initialize(objects, table, view)
      @view_context     = view
      @table_definition = table
      @objects          = objects
      @table            = table_definition.new(objects, view)
    end

    # Short hand so your fingers don't hurt
    def v
      view_context
    end

    def render_table
      raise NoMethodError, "You must override the .render method"
    end

    def render_header
      raise NoMethodError, "You must override the .header method"
    end

    def render_rows
      raise NoMethodError, "You must override the .rows method"
    end

    def column_names
      table.column_names
    end

    def row_values(object)
      table.columns.each_with_object([]) do |(key, column), values|
        values << column.value(object, view_context, table)
      end
    end

    def rows
      objects.each_with_object([]) do |object, row|
        row << row_values(object)
      end
    end

    def wrapper_tag(type, value=nil, options={}, &block)
      table_config = table.class.config.send(type).to_hash
      tag_options = TableCloth.config_for(type)
      tag_options.merge!(table_config)
      tag_options.merge!(options)

      content = if block_given?
        v.content_tag(type, tag_options, &block)
      else
        v.content_tag(type, value, tag_options)
      end
    end
  end
end