class GenomerPluginSimple < Genomer::Plugin

  def initialize(arguments,settings = {})
    @arguments = arguments
  end

  def run
    case @arguments.shift
    when nil        then 'Plugin "simple" called'
    when 'echo'     then @arguments.unshift('Echo:').join(' ')
    when 'describe' then "The scaffold contains #{scaffold.length} entries"
    end
  end

end
