require 'test_helper'
# test class for BookSlot
class Structure::BookSlotTest < MiniTest::Unit::TestCase

  attr_accessor :slot, :slot_with_label, :master, :dmaker, :master2, :dmaker2,
                :unknown, :slot_multiple

  def setup
    @slot = Structure::BookSlot.new
    @slot_with_label = Structure::BookSlot.new(label: 'howdy!',
                                               name:  'nyu_aco000123_n0009897')
    @master  = Filename.new('a_m.tif')
    @dmaker  = Filename.new('a_d.tif')
    @master2 = Filename.new('b_m.tif')
    @dmaker2 = Filename.new('b_d.tif')

    @slot_multiple = Structure::BookSlot.new
    slot_multiple.add(dmaker)
    slot_multiple.add(master)
    slot_multiple.add(dmaker2)
    slot_multiple.add(master2)

    @unknown = Filename.new('c_blerf.xyz')
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

  def test_label
    expected = 'nyu_aco000123_n0009897'
    assert_equal expected, slot_with_label.name
  end

  def test_default_filenames
    expected = {}
    assert_equal expected, slot.filenames
  end

  def test_add_master
    expected = { master: [master] }
    slot.add(master)
    assert_equal expected, slot.filenames
  end

  def test_add_dmaker
    expected = { dmaker: [dmaker] }
    slot.add(dmaker)
    assert_equal expected, slot.filenames
  end

  def test_add_multiple
    expected = { dmaker: [dmaker, dmaker2], master: [master, master2] }
    assert_equal expected, slot_multiple.filenames
  end

  def test_exception_on_invalid_role
    assert_raises(ArgumentError) { slot.add(unknown) }
  end

  def test_retrieve_filenames
    expected = [dmaker, dmaker2]
    assert_equal expected, slot_multiple.dmakers
  end
end
