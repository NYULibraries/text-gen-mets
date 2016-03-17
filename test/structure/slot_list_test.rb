require 'test_helper'
require 'ostruct'
# test class for SlotList
class Structure::SlotListTest < MiniTest::Unit::TestCase

  attr_accessor :slot_list, :args, :dmakers, :masters, :slots,
                :dmaker1, :dmaker2, :master1, :master2
  def setup
    @args = OpenStruct.new
    @args.slot_class = Structure::BookSlot

    @dmaker1 = Filename.new('j/k/x_d.tif')
    @dmaker2 = Filename.new('j/k/y_d.tif')
    @dmakers = [dmaker1, dmaker2]

    @master1 = Filename.new('j/k/x_m.tif')
    @master2 = Filename.new('j/k/y_m.tif')
    @masters = [master1, master2]

    @slots   = begin
                 one = Structure::BookSlot.new
                 one.add(dmaker1)
                 one.add(master1)
                 two = Structure::BookSlot.new
                 two.add(dmaker2)
                 two.add(master2)
                 [one, two]
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
    skip('pending refactor of BookSlot')
    args.dmakers = dmakers
    args.masters = masters
    sl = Structure::SlotList.new(args)
    assert_equal(slots, sl.slots)
  end
end
