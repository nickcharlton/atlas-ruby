require "date"

module Atlas
  class Resource
    include Validations

    INTERNAL_ATTRIBUTE_KEYS = %w(@tag @url_builder).freeze

    attr_accessor :tag, :url_builder

    def initialize(tag, hash = {})
      @tag = tag
      @url_builder = UrlBuilder.new tag

      hash.each { |k, v| send("#{k}=", v) if respond_to?("#{k}=") }
    end

    def update_with_response(response, except_keys = [])
      # remove keys that shouldn't be included
      except_keys.each { |k| response.delete(k) }

      response.each { |k, v| send("#{k}=", v) if respond_to?("#{k}=") }
    end

    def attributes
      instance_variables.map do |v|
        INTERNAL_ATTRIBUTE_KEYS.include?(v.to_s) ? next : v.to_s.sub(/^@/, "")
      end.compact!
    end

    def to_hash
      Hash[attributes.map { |v| [v.to_sym, send(v)] }]
    end

    def inspect
      objects = to_hash.map { |k, v| "#{k}=#{v.inspect}" }.join(' ')
      "#<#{self.class.name}:#{object_id} #{objects}>"
    end

    class << self
      def date_writer(*args)
        args.each do |attr|
          define_method("#{attr}=".to_sym) do |date|
            date = date.is_a?(String) ? Time.parse(date) : date
            instance_variable_set("@#{attr}", date)
          end
        end
      end

      def date_accessor(*args)
        attr_reader(*args)
        date_writer(*args)
      end
    end
  end
end
