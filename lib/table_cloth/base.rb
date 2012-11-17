module TableCloth
  class Base
    NoPresenterError = Class.new(Exception)

    attr_reader :collection, :view
    class_attribute :config, instance_accessor: false
    self.config = Class.new { include ConfigurableElements }

    def initialize(collection, view)
      @collection = collection
      @view       = view
    end

    def column_names
      @column_names ||= columns.each_with_object([]) do |(column_name, column), names|
        names << column.human_name
      end
    end

    def columns
      @columns ||= self.class.columns.each_with_object({}) do |(column_name, column), columns|
        columns[column_name] = column if column.available?(self)
      end
    end

    def has_actions?
      self.class.has_actions?
    end

    class << self
      def presenter(klass=nil)
        return @presenter = klass if klass

        @presenter || (superclass.respond_to?(:presenter) ? superclass.presenter : NoPresenterError.new("No Presenter"))
      end

      def column(*args, &block)
        options = args.extract_options! || {}
        options[:proc] = block if block_given?

        column_class = options.delete(:using) || Column

        args.each do |name|
          add_column name, column_class.new(name, options)
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

      def actions(options={}, &block)
        if block_given?
          actions = Actions.new(options, &block)
          columns[:actions] = actions.column
        end

        columns[:actions].actions
      end

      def has_actions?
        columns[:actions].present?
      end
    end
  end
end