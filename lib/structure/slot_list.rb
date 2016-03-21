module Structure
  # class deals with aggregations of Slots
  # initialize with masters and dmakers
  #
  # messages:
  # SlotList.new passed dmakers and masters
  # create slots
  # load dmakers into slots
  # load masters into slots
  # if slot not found for master
  class SlotList
    attr_reader :dmakers, :masters, :slot_class
    attr_accessor :slots
    def initialize(args)
      @dmakers = args.dmakers
      @masters = args.masters
      @slot_class = args.slot_class
      @slots = {}

      raise(ArgumentError, 'dmakers cannot be nil') unless dmakers
      raise(ArgumentError, 'masters cannot be nil') unless masters
      raise(ArgumentError, 'slot_class cannot be nil') unless slot_class

      populate_slots
    end

    def ==(other)
      result &&= (self.dmakers == other.dmakers)
      result
    end

    private

    def populate_slots
      create_slots
      load_dmakers
      load_masters
    end

    def create_slots
      dmakers.each do |dmaker|
        slot_name = dmaker_to_slot_name(dmaker)
        slots[slot_name] = slot_class.new(name: slot_name)
      end
    end

    def load_dmakers
      dmakers.each do |dmaker|
        slot_name = dmaker_to_slot_name(dmaker)
        slot = slots[slot_name]
        raise(RuntimeError, "missing slot for #{slot_name}") unless slot
        slot.add(dmaker)
      end
    end

    def load_masters
      masters.each do |master|
        slot_name = master_to_slot_name(master)
        slot = slots[slot_name]
        raise(RuntimeError, "missing slot for #{slot_name}") unless slot
        slot.add(master)
      end
    end

    def dmaker_to_slot_name(dmaker)
      dmaker.rootname_minus_role
    end

    def master_to_slot_name(master)
      master.rootname_minus_role
    end
  end
end
