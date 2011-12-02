class Genomer::Plugin

  def self.plugins
    require 'bundler'
    Bundler.setup.gems.select{|gem| gem.name =~ /genomer-plugin-.+/ }
  end

  def self.to_class_name(string)
    string.split('-').map{|i| i.capitalize}.join
  end

end
