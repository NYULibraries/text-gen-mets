# deals with DLTS filename idiosyncracies
class Filename

  # messages:
  #  extension
  #  rootname
  #  name
  #  path
  #  role

  attr_reader :path, :extension, :rootname
  def initialize(path)
    @path = path
    @extension = File.extname(path)
    @rootname  = File.basename(path).sub(/#{extension}\z/, '')
  end
end
  
    
