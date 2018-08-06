module Puppet::ResourceApi::Property
  def should
    if data_type.is_a? Puppet::Pops::Types::PBooleanType
      # work around https://tickets.puppetlabs.com/browse/PUP-2368
      rs_value ? :true : :false # rubocop:disable Lint/BooleanSymbol
    elsif name == :ensure && rs_value.is_a?(String)
      rs_value.to_sym
    else
      rs_value
    end
  end

  def should=(value)
    @shouldorig = value

    if name == :ensure
      value = value.to_s
    end

    # Puppet requires the @should value to always be stored as an array. We do not use this
    # for anything else
    # @see Puppet::Property.should=(value)
    @should = [Puppet::ResourceApi.mungify(data_type, value, "#{resource.type.to_s}.#{name}")]
  end

  # used internally
  # @returns the final mungified value of this parameter
  def rs_value
    @should ? @should.first : @should
  end
end
