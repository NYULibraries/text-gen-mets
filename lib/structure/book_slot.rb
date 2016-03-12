# class handles book digitization slots
# objects of this class respond to the following messages:
#  label
#  masters -> array of filename objects
#  dmakers -> array of filename objects
#  valid?

module Structure
  class BookSlot
    attr_accessor :label
    def initialize(args = {})
      @label = args[:label] || ''
    end
  end
end
