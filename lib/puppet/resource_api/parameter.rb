module Puppet::ResourceApi::Parameter
  def value
    @value
  end

  def value=(value)
    @value = Puppet::ResourceApi.mungify(data_type, value, "#{resource.type.to_s}.#{name}")
  end

  # used internally
  # @returns the final mungified value of this parameter
  def rs_value
    @value
  end
end
