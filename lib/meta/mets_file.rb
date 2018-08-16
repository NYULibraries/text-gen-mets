module Meta
  # class stores file attributes required to generate METS documents

  # attributes:
  #   path
  #   filename
  #   mets_id
  #   mdtype
  #   othermdtype
  
  class METSFile
    # args hash must have the following key/value pairs:
    # :path
    # :id
    # :mdtype
    # :othermdtype if value of :metstype is "OTHER"
    def initialize(args, options = {})
      @args = args
      validate!
    end

    private
    def validate!
      errors = []
      errors << 'args must be a hash' unless @args.class == Hash
      
      [:path, :mdtype, :id].each do |k| 
        errors << "missing :#{k} key/value pair' if (args[k].nil? || args[k].empty?)"
      end
      raise ArgumentError, errors.to_s unless errors.empty?
    end

  end
end


