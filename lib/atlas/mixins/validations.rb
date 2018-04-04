module Atlas
  module Validations
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end

    module InstanceMethods
      def validate!
        missing = self.class.required_attributes[self.class.name].reject do |k|
          to_hash.include?(k) && !to_hash[k].nil?
        end

        if missing.any?
          raise Atlas::Errors::InvalidResourceError,
            "Missing attributes: #{missing.join(', ')}"
        end
      end
    end

    module ClassMethods
      @@required_attributes = {}

      def requires(*args)
        args.each { |attr| (@@required_attributes[name] ||= []) << attr }
      end

      def required_attributes
        @@required_attributes
      end
    end
  end
end
