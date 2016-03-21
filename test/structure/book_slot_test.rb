require 'test_helper'
module Structure
  # test class for BookSlot
  class BookSlotTest < MiniTest::Unit::TestCase
    attr_accessor :slot, :slot_with_label, :master, :dmaker, :master2, :dmaker2,
                  :dmaker3, :unknown, :slot_multiple, :slot_multiple2

    def setup
      @slot = Structure::BookSlot.new
      @slot_with_label = Structure::BookSlot.new(label: 'howdy!',
                                                 name:  'nyu_aco000123_n0009897')
      @master  = Filename.new('a_m.tif')
      @dmaker  = Filename.new('a_d.tif')
      @master2 = Filename.new('b_m.tif')
      @dmaker2 = Filename.new('b_d.tif')
      @dmaker3 = Filename.new('c_d.tif')

      @slot_multiple = Structure::BookSlot.new
      slot_multiple.add(dmaker)
      slot_multiple.add(master)
      slot_multiple.add(dmaker2)
      slot_multiple.add(master2)

      @slot_multiple2 = Structure::BookSlot.new
      slot_multiple2.add(dmaker)
      slot_multiple2.add(master)
      slot_multiple2.add(dmaker2)
      slot_multiple2.add(master2)

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

    def test_retrieve_dmakers
      expected = [dmaker, dmaker2]
      assert_equal expected, slot_multiple.dmakers
    end

    def test_retrieve_masters
      expected = [master, master2]
      assert_equal expected, slot_multiple.masters
    end

    def test_equals_true
      assert slot_multiple == slot_multiple2
    end

    def test_equals_false_filenames
      slot_multiple2.add(dmaker3)
      refute slot_multiple == slot_multiple2
    end

    def test_equals_false_label
      slot_multiple2.label = 'foo foo foo'
      refute slot_multiple == slot_multiple2
    end

    def test_equals_false_name
      slot_multiple2.name = 'foo foo foo'
      refute slot_multiple == slot_multiple2
    end
  end
end
