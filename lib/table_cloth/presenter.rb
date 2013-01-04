module TableCloth
  class Presenter
    attr_reader :view_context, :table_definition, :objects,
      :table

    def initialize(objects, table, view)
      @objects = objects
      @table_definition = table
      @view_context = view
      @table = table_definition.new(objects, view)
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

    def columns
      @columns ||= table.class.columns.map do |name, options|
        column = options[:class].new(name, options[:options])

        if ColumnJury.new(column, table).available?
          column
        else
          nil
        end
      end.compact
    end

    def column_names
      @column_names ||= columns.each_with_object([]) do |column, names|
        names << column.human_name
      end
    end

    def row_values(object)
      columns.each_with_object([]) do |column, values|
        values << column.value(object, view_context, table)
      end
    end

    def rows
      objects.each_with_object([]) do |object, row|
        row << row_values(object)
      end
    end

    def wrapper_tag(type, value=nil, options={}, &block)
      options = tag_options(type, options)

      content = if block_given?
        v.content_tag(type, options, &block)
      else
        v.content_tag(type, value, options)
      end
    end

    private

    def tag_options(type, options={})
      options = options.dup
      options.merge!(table.config[type])
      options.merge!(TableCloth.config_for(type))
    end
  end
end