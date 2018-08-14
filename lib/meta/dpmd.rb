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
      @analyzed = false
    end

    def analyze
      FILES.each_pair { |k, f| files[k] = Dir.glob(File.join(dir, "*#{f}")) }
      @analyzed = true
    end

    def valid?
      # guard against #valid? being called before analysis
      analyze unless @analyzed
      errors = []
      validate
      errors.empty?
    end
    
    def validate
      FILES.each_pair do |k, v|
        err_msg = "missing or too many files ending in #{v}" 
        errors <<  err_msg unless files[k].length == 1
      end
    end

  end
end
