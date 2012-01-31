class GenomerPluginSimple < Genomer::Plugin

  def run
    case arguments.shift
    when nil           then 'Plugin "simple" called'
    when 'echo'        then "Echo: #{arguments.join(' ')}"
    when 'describe'    then "The scaffold contains #{scaffold.length} entries"
    when 'annotations' then annotations
    end
  end

  def annotations
    args = Hash.new
    args[:prefix] = flags[:prefix] if flags[:prefix]
    args[:reset]  = flags[:reset_locus_numbering] if flags[:reset_locus_numbering]
    super(args).inject("##gff-version 3\n"){|s, a| s << a.to_s}
  end

end
