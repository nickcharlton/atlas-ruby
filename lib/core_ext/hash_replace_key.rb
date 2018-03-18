module HashReplaceKey
  def replace_key(original, replacement)
    dup.replace_key!(original, replacement)
  end

  def replace_key!(original, replacement)
    return self unless has_key?(original)

    self[replacement] = delete(original)

    self
  end
end

class Hash
  include HashReplaceKey
end
