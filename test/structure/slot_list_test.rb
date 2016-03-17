require 'test_helper'
require 'ostruct'
# test class for SlotList
class Structure::SlotListTest < MiniTest::Unit::TestCase

  attr_accessor :slot_list, :args
  def setup
    @args = OpenStruct.new
  end

  def test_incoming_arguments_dmakers_nil
    args.masters = []
    assert_raises(ArgumentError) { Structure::SlotList.new(args) }
  end
end
