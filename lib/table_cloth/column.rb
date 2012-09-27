module TableCloth
  class Column
    attr_reader :options, :name

    def initialize(name, options)
      @name    = name
      @options = options
    end
  end
end