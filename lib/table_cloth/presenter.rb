module TableCloth
  class Presenter
    attr_reader :view_context, :table_definition, :objects

    def initialize(objects, table, view)
      @view_context     = view
      @table_definition = table
      @objects          = objects
    end

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
      table_definition.columns.inject([]) do |names, (key,column)|
        names << (column.options[:name] || key.to_s.humanize)
        names
      end
    end

    def row_values(object)
      table_definition.columns.inject([]) do |values, (key, column)|
        values << column.value(object, view_context)
        values
      end
    end

    def rows
      objects.inject([]) do |row, object|
        row << row_values(object)
        row
      end
    end
  end
end