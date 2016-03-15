# class handles book digitization slots
# objects of this class respond to the following messages:
#  label
#  valid?

module Structure
  class BookSlot
    attr_accessor :label, :name, :filenames

    VALID_ROLES = [:master, :dmaker]
    def initialize(args = {})
      @label = args[:label] || ''
      @name  = args[:name]
      @filenames = args[:filenames] || {}
    end

    def add(filename)
      role = filename.role
      raise ArgumentError unless VALID_ROLES.include?(role)

      # if there is already an array for this role, then add filename
      # otherwise, insert a new key/value pair
      if filenames[role]
        filenames[role] << filename
      else
        filenames[role] = [filename]
      end
    end
  end
end
