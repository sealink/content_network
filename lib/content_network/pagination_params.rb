module ContentNetwork
  class PaginationParams
    def self.build(params)
      new(params.slice(*ATTRS))
    end

    ATTRS = %i(page)

    attr_reader *ATTRS

    def initialize(page: 1)
      @page = page
    end

    def to_h
      {
        page: @page
      }
    end
  end
end
