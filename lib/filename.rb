# deals with DLTS filename idiosyncracies
class Filename

  # messages:
  #  extension
  #  rootname
  #  name
  #  path
  #  role

  def self.role(rn)
    case rn
    when /_m\z/ then :master
    when /_d\z/ then :dmaker
    else :unknown
    end
  end
  
  attr_reader :path, :extension, :rootname, :name, :role
  def initialize(path)
    @path      = path
    @extension = File.extname(path)
    @name      = File.basename(path)
    @rootname  = name.sub(/#{extension}\z/, '')
    @role      = self.class.role(rootname)
  end
end
  
    
