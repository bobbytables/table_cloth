module TableCloth
  class Base
    attr_reader :collection, :view

    def initialize(collection, view)
      @collection = collection
      @view       = view
    end

    def column_names
      columns.inject([]) do |names, (column_name, column)|
        if column.available?(self)
          names << column.human_name
        end

        names
      end + (has_actions? ? ['Actions'] : [])
    end

    def columns
      self.class.columns
    end

    def has_actions?
      self.class.has_actions?
    end

    class << self
      attr_reader :presenter

      def presenter(klass)
        @presenter = klass
      end

      def column(*args, &block)
        options = args.extract_options! || {}
        options[:proc] = block if block_given?

        args.each do |name|
          add_column name, Column.new(name, options)
        end
      end

      def columns
        @columns ||= {}
        if superclass.respond_to? :columns
          @columns = superclass.columns.merge(@columns)
        end

        @columns
      end

      def add_column(name, column)
        @columns ||= {}
        @columns[name] = column
      end

      def action(*args, &block)
        options        = args.extract_options! || {}
        options[:proc] = block if block_given?

        name = args.shift
        add_action Action.new(name, options)
      end

      def add_action(action)
        unless has_actions?
          columns[:actions] = Columns::Action.new(:actions)
        end

        columns[:actions].actions << action
      end

      def has_actions?
        columns[:actions].present?
      end
    end
  end
end