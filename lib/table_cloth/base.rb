module TableCloth
  class Base
    class << self
      attr_reader :presenter

      def column(*args, &block)
        options = args.extract_options! || {}
        options[:proc] = block if block_given?

        args.each do |name|
          columns[name] = Column.new(name, options)
        end
      end

      def columns
        @columns ||= {}

        if superclass.respond_to? :columns
          @columns = superclass.columns.merge(@columns)
        end

        @columns
      end

      def presenter(klass)
        @presenter = klass
      end

      def action(*args, &block)
        options        = args.extract_options! || {}
        options[:proc] = block if block_given?

        args.each do |action|
          actions << Action.new(action, options)
        end
      end

      def actions
        @actions ||= []

        if superclass.respond_to? :actions
          @actions += superclass.actions
        end

        @actions
      end
    end
  end
end