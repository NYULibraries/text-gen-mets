# deals with DLTS filename idiosyncracies
class Filename

  # messages:
  #  extension
  #  rootname
  #  name
  #  path
  #  role

  attr_reader :path, :extension
  def initialize(path)
    @path = path
    @extension = File.extname(path)
  end



  
end
  
    
