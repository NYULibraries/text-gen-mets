# deals with digital provenance metadata
module Meta
  class Dpmd

    FILES = {
      eoc:    '_eoc.csv'.freeze,
      target: '_ztarget_m.tif'.freeze
    }

    attr_reader :errors, :dir, :files

    def initialize(dir, options = {})
      @dir     = dir
      @options = options
      @errors  = []
      @files   = {}
    end

    def analyze
      puts dir
      FILES.each_pair { |k, f| files[k] = Dir.glob(File.join(dir, "*#{f}")) }
    end

    def valid?
    end
  end
end
