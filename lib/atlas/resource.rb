module Atlas
  # Base class for representing resources.
  class Resource
    def initialize(hash = {})
      hash.each { |k, v| send("#{k}=", v) if respond_to?("#{k}=") }
    end

    def to_hash
      attrs = instance_variables.map { |v| v.to_s.sub(/^@/, '') }
      Hash[attrs.select { |v| respond_to? v }.map { |v| [v.to_sym, send(v)] }]
    end

    def inspect
      objects = to_hash.map { |k, v| "#{k}=#{v.inspect}" }.join(' ')
      "#<#{self.class.name}:#{object_id} #{objects}>"
    end
  end
end
