module TableCloth
  class Base
    class << self
      def column(*args, &block)
        options = args.extract_options! || {}
        options[:proc] = block if block_given?
        
        args.each do |name|
          columns << Column.new(name, options)
        end
      end

      def columns
        @columns ||= []
      end
    end
  end
end