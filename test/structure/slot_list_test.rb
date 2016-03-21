require 'test_helper'
require 'ostruct'
module Structure
  # test class for SlotList
  class SlotListTest < MiniTest::Test
    attr_accessor :args, :dmakers, :masters, :slots, :slots1

    def setup
      @args = OpenStruct.new
      @args.slot_class = Structure::BookSlot

      @dmakers = ['j/k/x_d.tif', 'j/k/y_d.tif'].collect { |d| Filename.new(d) }
      @masters = ['j/k/x_m.tif', 'j/k/y_m.tif'].collect { |m| Filename.new(m) }

      @slots = begin
                     a = {}
                     dmakers.each_index do |i|
                       slot_name = dmakers[i].rootname_minus_role
                       a[slot_name] = Structure::BookSlot.new(name: slot_name)
                       a[slot_name].add(dmakers[i])
                       a[slot_name].add(masters[i])
                     end
                     a
                   end

      @slots1 = begin
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
  end
end
