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
      column_values = table.columns.inject([]) do |values, (key, column)|
        values << column.value(object, view_context); values
      end
    end

    def rows
      objects.inject([]) do |row, object|
        row << row_values(object); row
      end
    end

    def wrapper_tag(type, value=nil, &block)
      content = if block_given?
        v.content_tag(type, TableCloth.config_for(type), &block)
      else
        v.content_tag(type, value, TableCloth.config_for(type))
      end
    end
  end
end