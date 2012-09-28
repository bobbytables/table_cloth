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
      end

      def presenter(klass)
        @presenter = klass
      end
    end

    presenter ::TableCloth::Presenters::Default
  end
end