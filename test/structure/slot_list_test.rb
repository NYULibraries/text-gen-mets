require 'test_helper'
require 'ostruct'
# test class for SlotList
class Structure::SlotListTest < MiniTest::Unit::TestCase

  attr_accessor :slot_list, :args, :dmakers, :masters, :slots

  def setup
    @args = OpenStruct.new
    @args.slot_class = Structure::BookSlot

    @dmakers = ['j/k/x_d.tif', 'j/k/y_d.tif'].collect { |d| Filename.new(d) }
    @masters = ['j/k/x_m.tif', 'j/k/y_m.tif'].collect { |m| Filename.new(m) }

    @slots   = begin
                 a = []
                 dmakers.each_index do |i|
                   a[i] = Structure::BookSlot.new
                   a[i].add(dmakers[i])
                   a[i].add(masters[i])
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
    skip('pending refactor of BookSlot')
    args.dmakers = dmakers
    args.masters = masters
    sl = Structure::SlotList.new(args)
    assert_equal(slots, sl.slots)
  end
end
