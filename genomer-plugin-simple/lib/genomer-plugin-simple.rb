class GenomerPluginSimple

  def initialize(arguments,settings = {})
    @arguments = arguments
  end

  def run
    case @arguments.shift
    when nil    then 'Plugin "simple" called'
    when 'echo' then @arguments.unshift('Echo:').join(' ')
    end
  end

end
