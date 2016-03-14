require 'test_helper'

class Structure::BookSlotTest < MiniTest::Unit::TestCase

  attr_accessor :slot, :slot_with_label
  
  def setup
    @slot = Structure::BookSlot.new()
    @slot_with_label = Structure::BookSlot.new(label: 'howdy!',
                                               name:  'nyu_aco000123_n0009897')
  end

  def test_empty_label
    expected = ''
    assert_equal expected, slot.label
  end

  def test_non_empty_label
    expected = 'howdy!'
    assert_equal expected, slot_with_label.label
  end

  def test_name
    expected = 'nyu_aco000123_n0009897'
    assert_equal expected, slot_with_label.name
  end    
end
