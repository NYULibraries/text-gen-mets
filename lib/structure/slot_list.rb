module Structure
  # class deals with aggregations of Slots
  # initialize with masters and dmakers
  # 
  class SlotList
    attr_reader :dmakers, :masters, :slot_class
    def initialize(args)
      @dmakers = args.dmakers
      @masters = args.masters
      @slot_class = args.slot_class

      raise(ArgumentError, 'dmakers cannot be nil') unless dmakers
      raise(ArgumentError, 'masters cannot be nil') unless masters
      raise(ArgumentError, 'slot_class cannot be nil') unless slot_class
    end

    def slots
      @slots ||= gen_slots
    end

    private

    def gen_slots
#      result = dmakers.collect { |dmaker| slot_class.new(dmaker) }
    end
  end
end
