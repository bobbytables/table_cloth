module TableCloth
  class Configuration
    cattr_accessor :table_class
    
    def self.configure(&block)
      yield
    end
  end
end