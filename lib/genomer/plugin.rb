class Genomer::Plugin

  def self.to_class_name(string)
    string.split('-').map{|i| i.capitalize}.join
  end

end
