module TableCloth
  module Extensions
    module RowAttributes

      extend ActiveSupport::Concern

      module ClassMethods

        def row_attributes(*args, &block)
          @tr_options ||= {}
          options = args.extract_options! || {}
          options[:proc] = block if block_given?
          @tr_options = options
        end

        def tr_options
          @tr_options ||= {}
          if superclass.respond_to? :tr_options
            @tr_options = superclass.tr_options.merge(@tr_options)
          end
          @tr_options
        end

        def tr_options_for(object, view_context)
          options = tr_options
          if options.include?(:proc)
            result = options[:proc].call(object, view_context) || {}
            options.except(:proc).merge(result)
          else
            options
          end
        end
      end
    end
  end
end
