module TableCloth
  class Base
    NoPresenterError = Class.new(Exception)

    attr_reader :collection, :view

    def initialize(collection, view)
      @collection = collection
      @view       = view
    end

    def config
      self.class.config
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
          add_column(class: column_class, options: options, name: name)
        end
      end

      def columns
        @columns ||= {}
        if superclass.respond_to? :columns
          @columns = superclass.columns.merge(@columns)
        end

        @columns
      end

      def add_column(options)
        @columns ||= {}
        @columns[options[:name]] = options
      end

      def config
        @config ||= Configuration.new
      end
    end
  end
end