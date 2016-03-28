require 'test_helper'
require 'ostruct'
module Structure
  # test class for SlotList
  class SlotListTest < MiniTest::Test
    attr_accessor :args, :dmakers, :masters, :masters_oversized

    def slots
      @slots ||= begin
                     a = {}
                     dmakers.each_index do |i|
                       slot_name = dmakers[i].rootname_minus_role
                       a[slot_name] = Structure::BookSlot.new(name: slot_name)
                       a[slot_name].add(dmakers[i])
                       a[slot_name].add(masters[i])
                     end
                     a
                   end
    end

    def array
      @each ||= slots.values
    end

    def slots1
      @slots1 ||= begin
                    a = {}
                    dmakers.each_index do |i|
                      slot_name = dmakers[i].rootname_minus_role
                      a[slot_name] = Structure::BookSlot.new(name: slot_name)
                      a[slot_name].add(dmakers[i])
                      a[slot_name].add(masters[i])
                    end
                    a
                  end
    end

    def slots_oversized
      @slots_oversized ||= begin
                             a = {}
                             dmakers.each_index do |i|
                               slot_name = dmakers[i].rootname_minus_role
                               a[slot_name] = Structure::BookSlot.new(name: slot_name)
                               a[slot_name].add(dmakers[i])
                             end
                             a[dmakers[0].rootname_minus_role].add(masters_oversized[0])
                             a[dmakers[1].rootname_minus_role].add(masters_oversized[1])
                             a[dmakers[1].rootname_minus_role].add(masters_oversized[2])
                             a[dmakers[1].rootname_minus_role].add(masters_oversized[3])
                             a[dmakers[1].rootname_minus_role].add(masters_oversized[4])
                             a
                           end
    end

    def setup
      @args = OpenStruct.new
      @args.slot_class = Structure::BookSlot

      @dmakers = ['j/k/x_d.tif', 'j/k/y_d.tif'].collect { |d| Filename.new(d) }
      @masters = ['j/k/x_m.tif', 'j/k/y_m.tif'].collect { |m| Filename.new(m) }
      @masters_oversized = ['j/k/x_m.tif',
                            'j/k/y_z01_m.tif',
                            'j/k/y_z02_m.tif',
                            'j/k/y_z03_m.tif',
                            'j/k/y_z04_m.tif'].collect { |m| Filename.new(m) }
    end

    def test_incoming_arguments_slot_class_nil
      args.masters = []
      args.dmakers = []
      args.slot_class = nil
      assert_raises(ArgumentError) { Structure::SlotList.new(args) }
    end

    def test_incoming_arguments_dmakers_nil
      args.masters = []
      assert_raises(ArgumentError) { Structure::SlotList.new(args) }
    end

    def test_incoming_arguments_masters_nil
      args.dmakers = []
      assert_raises(ArgumentError) { Structure::SlotList.new(args) }
    end

    def test_incoming_arguments_masters_nil
      args.dmakers = []
      assert_raises(ArgumentError) { Structure::SlotList.new(args) }
    end

    def test_slots
      args.dmakers = dmakers
      args.masters = masters
      sl = Structure::SlotList.new(args)
      assert_equal(slots, sl.slots)
    end

    def test_default_reversed?
      args.dmakers = dmakers
      args.masters = masters
      sl = Structure::SlotList.new(args)
      refute sl.reversed?
    end

    def test_reversed!
      args.dmakers = dmakers
      args.masters = masters
      sl = Structure::SlotList.new(args)
      refute sl.reversed?
      sl.reverse!
      assert sl.reversed?
    end

    def test_to_a
      args.dmakers = dmakers
      args.masters = masters
      sl = Structure::SlotList.new(args)
      assert_equal(array, sl.to_a)
    end

    def test_to_a_reversed
      args.dmakers = dmakers
      args.masters = masters
      sl = Structure::SlotList.new(args)
      sl.reverse!
      assert_equal(array.reverse, sl.to_a)
    end

    def test_oversized_assignment
      args.dmakers = dmakers
      args.masters = masters_oversized
      sl = Structure::SlotList.new(args)
      assert_equal(slots_oversized, sl.slots)
    end

    def test_valid?
      args.dmakers = dmakers
      args.masters = masters_oversized
      sl = Structure::SlotList.new(args)
      assert sl.valid?
    end

    def test_not_valid?
      args.dmakers = dmakers
      args.masters = [Filename.new('j/k/x_m.tif')]
      sl = Structure::SlotList.new(args)
      refute sl.valid?
    end
  end
end
