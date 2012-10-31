module TableCloth
  class Actions
    attr_reader :column, :options

    def initialize(options={}, &block)
      @options = options
      @column = Columns::Action.new(:actions, options)

      block.arity > 0 ? block.call(self) : instance_eval(&block)
    end

    def action(*args, &block)
      options        = args.extract_options! || {}
      options[:proc] = block if block_given?

      column.actions << Action.new(options)
    end

    def all
      column.actions
    end
  end
end