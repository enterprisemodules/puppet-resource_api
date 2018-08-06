module Puppet::ResourceApi::ReadOnlyParameter
  def value
    @value
  end

  def value=(value)
    raise Puppet::ResourceError, "Attempting to set `#{name}` read_only attribute value to `#{value}`"
  end

  # used internally
  # @returns the final mungified value of this parameter
  def rs_value
    @value
  end
end
