# deals with DLTS filename idiosyncracies
class Filename

  # messages:
  #  extension
  #  rootname
  #  name
  #  path
  #  role

  attr_reader :path, :extension, :rootname, :name
  def initialize(path)
    @path = path
    @extension = File.extname(path)
    @name      = File.basename(path)
    @rootname  = name.sub(/#{extension}\z/, '')
  end
end
  
    
