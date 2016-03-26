module Structure
  # class deals with book digitization slots file grouping
  class BookSlot
    attr_accessor :label, :name, :filenames

    VALID_ROLES = [:master, :dmaker].freeze

    def initialize(args = {})
      @label = args[:label] || ''
      @name  = args[:name]
      @filenames = {}
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

    # create accessors for filename arrays
    VALID_ROLES.each do |sym|
      # note pluralized form of role, e.g., #dmakers
      define_method("#{sym}s") do
        filenames[sym]
      end
    end

    def ==(other)
      result = true
      result &&= (self.label == other.label)
      result &&= (self.name  == other.name)
      result &&= (self.filenames == other.filenames)
    end

    def valid?
      assert_d_m_count
    end

    private

    def assert_d_m_count
      result = true
      result &&= (dmakers.count == 1)
      result &&= (masters.count >= 1)
    end
  end
end
