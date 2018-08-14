# deals with digital provenance metadata
module Meta
  class Dpmd

    FILES = {
      eoc:    '_eoc.csv'.freeze,
      target: '_ztarget_m.tif'.freeze
    }

    attr_reader :dir, :files, :errors

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
      @errors = []
      validate
      @errors.empty?
    end
    

    # perhaps this method is too cute... I'm using the FILES keys as
    # the basis of the options hash keys. This assumes that the
    # options hash looks like this: @options[:no_<FILES key>] = true.
    # This approach allows me to use a loop, but it feels a little
    # brittle in that I'm generating the options hash key from the
    # FILES key.
    def validate
      FILES.each_pair do |k, v|
        # :no_eoc, :no_master
        if @options["no_#{k}".to_sym]
          if files[k].length != 0
            ftype = k.to_s.upcase
            emsg = "#{ftype} FILE DETECTED. THIS SCRIPT IS FOR DIRS W/O #{ftype} FILES\n"
            @errors << emsg
          end
        else
          emsg = "missing or too many files ending in #{v}" 
          @errors <<  emsg unless files[k].length == 1
        end
      end
    end

  end
end
