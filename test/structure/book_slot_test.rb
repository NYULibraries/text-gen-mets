require 'test_helper'

class Structure::BookSlotTest < MiniTest::Unit::TestCase

  attr_accessor :slot, :slot_with_label
  
  def setup
    @slot = Structure::BookSlot.new()
    @slot_with_label = Structure::BookSlot.new(label: 'howdy!')

  end

  def test_empty_label
    expected = ''
    assert_equal expected, slot.label
  end

  def test_non_empty_label
    expected = 'howdy!'
    assert_equal expected, slot_with_label.label
  end
end
