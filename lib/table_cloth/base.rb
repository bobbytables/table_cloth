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

    class << self
      def presenter(klass=nil)
        return @presenter = klass if klass
        return @presenter if @presenter

        if superclass.respond_to?(:presenter)
          superclass.presenter
        else
          raise NoPresenterError, "No Presenter"
        end
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
        @columns[options[:name]] = options
      end
    end
  end
end