module TableCloth::Extensions::Actions
  class Action
    attr_reader :options

    def initialize(options={})
      @options = options
    end

    def jury
      @jury ||= Jury.new(self)
    end

    def value(object, view, table)
      if jury.available?(object, table)
        view.instance_exec(object, &options[:proc])
      else
        ""
      end
    end
  end
end
