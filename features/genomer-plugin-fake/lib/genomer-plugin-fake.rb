class GenomerPluginFake

  def initialize(arguments,settings = {})
    @arguments = arguments
  end

  def run
    msg = 'Plugin "fake" called'
    msg << @arguments.unshift(' with arguments:').join(' ') unless arguments.empty?
    msg
  end

end
