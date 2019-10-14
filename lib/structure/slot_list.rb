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
    attr_reader :dmakers, :masters, :originals, :slot_class
    attr_accessor :slots

    def initialize(args)
      @dmakers    = args.dmakers
      @masters    = args.masters
      @originals  = args.originals
      @slot_class = args.slot_class
      @slots = {}
      @reverse = false

      if (masters.nil? && originals.nil?)
        raise(ArgumentError, 'masters and originals cannot be nil') 
      end
      raise(ArgumentError, 'dmakers cannot be nil')    unless dmakers
      raise(ArgumentError, 'slot_class cannot be nil') unless slot_class

      populate_slots
    end

    def ==(other)
      result &&= (self.dmakers == other.dmakers)
      result
    end

    def valid?
      slots.values.inject { |a = true, e| a && e.valid? }
    end

    def reversed?
      @reverse
    end

    def reverse!
      @reverse = !@reverse
    end

    def to_a
      reversed? ? slots.values.reverse : slots.values
    end

    private

    def populate_slots
      create_slots
      load_dmakers
      load_masters   if masters
      load_originals if originals
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
        raise "missing slot for #{dmaker.path}" unless slot
        slot.add(dmaker)
      end
    end

    def load_masters
      masters.each do |master|
        slot = slots[master_to_slot_name(master)] ||
               slots[master_to_slot_name_parent(master)]
        raise "missing slot for #{master.path}" unless slot
        slot.add(master)
      end
    end

    def load_originals
      originals.each do |original|
        slot = slots[original_to_slot_name(original)] ||
               slots[original_to_slot_name_parent(original)]
        raise "missing slot for #{original.path}" unless slot
        slot.add(original)
      end
    end

    def dmaker_to_slot_name(dmaker)
      dmaker.rootname_minus_role
    end

    def master_to_slot_name(master)
      master.rootname_minus_role
    end

    def original_to_slot_name(original)
      original.rootname_minus_role
    end

    def master_to_slot_name_parent(master)
      master.rootname_minus_index_and_role
    end
  end
end
