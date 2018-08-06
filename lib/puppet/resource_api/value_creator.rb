class Puppet::ResourceApi::ValueCreator
  def initialize(resource_class, data_type, param_or_property, specified_type)
    @resource_class = resource_class
    @data_type = data_type
    @param_or_property = param_or_property
    @specified_type = specified_type
  end

  def create_values
    case @data_type
    when Puppet::Pops::Types::PStringType
      # require any string value
      def_newvalues(@resource_class, %r{})
    when Puppet::Pops::Types::PBooleanType
      def_newvalues(@resource_class, 'true', 'false')
      @resource_class.aliasvalue true, 'true'
      @resource_class.aliasvalue false, 'false'
      @resource_class.aliasvalue :true, 'true' # rubocop:disable Lint/BooleanSymbol
      @resource_class.aliasvalue :false, 'false' # rubocop:disable Lint/BooleanSymbol
    when Puppet::Pops::Types::PIntegerType
      def_newvalues(@resource_class, %r{^-?\d+$})
    when Puppet::Pops::Types::PFloatType, Puppet::Pops::Types::PNumericType
      def_newvalues(@resource_class, Puppet::Pops::Patterns::NUMERIC)
    end

    def_call_provider() if @param_or_property == :newproperty

    case @specified_type
    when 'Enum[present, absent]'
      def_newvalues(@resource_class, 'absent', 'present')
    end
  end

  # Add the value to `this` property or param, depending on whether
  # param_or_property is `:newparam`, or `:newproperty`.
  def def_newvalues(this, *values)
    if @param_or_property == :newparam
      this.newvalues(*values)
    else
      values.each do |v|
        this.newvalue(v) {}
      end
    end
  end

  # stop puppet from trying to call into the provider when
  # no pre-defined values have been specified
  # "This is not the provider you are looking for." -- Obi-Wan Kaniesobi.
  def def_call_provider
    @resource_class.send(:define_method, :call_provider) { |value| }
  end
end
