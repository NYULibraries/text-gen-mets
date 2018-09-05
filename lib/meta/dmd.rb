# deals with descriptive metadata
module Meta
  class Dmd

    MARCXML_HASH = { suffix: '_marcxml.xml', mdtype: 'OTHER', othermdtype: 'MARCXML' }
    MODS_HASH    = { suffix: '_mods.xml',    mdtype: 'MODS',  othermdtype: '' }

    attr_reader :dir, :files, :errors

    def initialize(dir, options = {})
      @dir     = dir
      @options = options
      @errors  = []
      @files   = []

      setup
    end

    def valid?
      # guard against #valid? being called before analysis
      #     analyze unless @analyzed
      reset_errors
      validate
      any_errors?
    end

    def validate
      check_unexpected_files
      check_expected_files
    end

    def ids
      get_ids
    end
    
    private
    def get_ids
      (files.collect { |v| v.id }).sort.join(' ')
    end

    def get_files(suffix)
      Dir.glob(File.join(dir, "*#{suffix}")) 
    end

    # check that certain files are NOT present
    # e.g., no eoc, no target
    def check_unexpected_files
      unexpected_files.each_pair do |k, v|
        if get_files(v[:suffix]).length != 0
          t = k.to_s.upcase
          add_error "#{t} FILE DETECTED. THIS SCRIPT IS FOR DIRS W/O #{t} FILES\n"
        end
      end
    end

    # check that certain files ARE present
    # e.g., eoc, target
    def check_expected_files
      expected_files.each_pair do |k, v|
        suffix = v[:suffix]
        unless get_files(suffix).length == 1
          add_error "missing or too many files ending in #{suffix}" 
        end
      end
    end

    def expected_files
      h = {}
      h[:marcxml] = MARCXML_HASH unless @options[:no_marcxml] 
      h[:mods]    = MODS_HASH    unless @options[:no_mods] 

      h
    end

    def unexpected_files
      h = {}
      h[:marcxml] = MARCXML_HASH if @options[:no_marcxml] 
      h[:mods]    = MODS_HASH    if @options[:no_mods] 

      h
    end

    def setup
      raise "in invalid state. cannot proceed. #{@errors}" unless valid?
      id_counter = 'dmd-00000000'
      expected_files.each_pair do |k, v|
        id_counter.succ!
        mf = METSFile.new(
          id: "#{id_counter}", 
          path: get_files(v[:suffix]).first,
          mdtype: v[:mdtype],
          othermdtype: v[:othermdtype]
        )

        @files << mf
      end
    end

    def reset_errors
      @errors = []
    end

    def add_error(emsg)
      @errors << emsg
    end

    def any_errors?
      @errors.empty?
    end
  end
end
