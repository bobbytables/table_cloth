module TableCloth
  class ColumnJury
    attr_reader :column, :table

    def initialize(column, table)
      @column, @table = column, table
    end

    def available?
      if options[:if] && options[:if].is_a?(Symbol)
        return !!table.send(options[:if])
      end

      if options[:unless] && options[:unless].is_a?(Symbol)
        return !table.send(options[:unless])
      end

      true
    end

    def options
      column.options
    end
  end
end