# class handles book digitization slots
# objects of this class respond to the following messages:
#  label
#  masters -> array of filename objects
#  dmakers -> array of filename objects
#  valid?

module Structure
  class BookSlot
    attr_accessor :label, :name, :files
    def initialize(args = {})
      @label = args[:label] || ''
      @name  = args[:name]
      @files = args[:files] || {}
    end
    def add(filename)
      type = filename.type
      # if there is already an array for this filetype, then add filename
      # otherwise, insert a new key/value pair
      files[type] ? files[type] << filename : files[type] = [filename]
    end
  end
end
