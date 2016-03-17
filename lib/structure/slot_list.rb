module Structure
  # class deals with aggregations of Slots
  # initialize with masters and dmakers
  # 
  class SlotList
    attr_reader :dmakers, :masters
    def initialize(args)
      @dmakers = args.dmakers
      @masters = args.masters

      raise(ArgumentError, 'dmakers cannot be nil') unless dmakers
    end
  end
end
