# deals with DLTS filename idiosyncracies
class Filename

  # messages:
  #  extension
  #  rootname
  #  name
  #  path
  #  role

  attr_accessor :path
  def initialize(path)
    @path = path
  end
end
  
    
