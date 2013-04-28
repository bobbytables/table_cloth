module TableCloth
  class Builder
    attr_accessor :table, :presenter

    def self.build(objects, view, options={}, &block)
      if block_given?
        table = Class.new(TableCloth::Base)
        block.call(table)
      else
        table_class = options.delete(:with)
        table = table_class.kind_of?(String) ? table_class.constantize : table_class
      end

      presenter = options.delete(:present_with) || table.presenter

      new.tap do |builder|
        builder.table     = table
        builder.presenter = presenter.new(objects, table, view)
      end
    end

    def to_s
      presenter.render_table
    end
  end
end