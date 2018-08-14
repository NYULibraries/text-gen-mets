require 'test_helper'
module Meta
  # test class for BookSlot
  class DpmdTest < MiniTest::Test

    ALL_FILES_DIR = 'test/fixtures/texts/valid/'

    raise "#{ALL_FILES_DIR} does not exist" unless File.exist?(ALL_FILES_DIR)

    def test_valid_directory
      sut = Meta::Dpmd.new(ALL_FILES_DIR)

      sut.analyze
      puts sut.files
    end
  end
end
