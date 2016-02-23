module ContentNetwork
  class PathParams
    def self.build(params)
      new(params.slice(*ATTRS))
    end

    ATTRS = %i(element_type section_name entry_type entry_id)

    attr_reader *ATTRS

    def initialize(element_type: 'Entry', section_name: 'all', entry_type: 'all', entry_id: 'all')
      @element_type = element_type
      @section_name = section_name
      @entry_type = entry_type
      @entry_id = entry_id
    end

    def path
      [@element_type, @section_name, @entry_type, @entry_id].join('/')
    end
  end
end
