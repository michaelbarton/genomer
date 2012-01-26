class GenomerPluginSimple < Genomer::Plugin

  def run
    case arguments.shift
    when nil           then 'Plugin "simple" called'
    when 'echo'        then @arguments.unshift('Echo:').join(' ')
    when 'describe'    then "The scaffold contains #{scaffold.length} entries"
    when 'annotations' then format_annotations
    end
  end

  def format_annotations
    string = "##gff-version 3\n"
    annotations.each{|a| a.seqname = 'scaffold' }.each{|a| string << a.to_s}
    string
  end

end
