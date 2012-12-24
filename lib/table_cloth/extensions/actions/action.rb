module TableCloth::Extensions::Actions
  class Action
    attr_reader :options

    def initialize(options={})
      @options = options
    end

    def jury
      @jury ||= Jury.new(self)
    end

    def value(object, view)
      if jury.available?(object)
        view.instance_exec(object, &options[:proc])
      else
        ""
      end
    end
  end
end