class GenomerPluginSimple

  def initialize(arguments,settings = {})
    @arguments = arguments
  end

  def run
    msg = 'Plugin "simple" called'
    msg << @arguments.unshift(' with arguments:').join(' ') unless @arguments.empty?
    msg
  end

end
