module ContentNetwork
  class Collection
    def initialize(response)
      @response = response
    end

    def data
      return nil if error?
      parsed_response['data']
    end

    def pagination?
      return false if error?
      parsed_response['meta'].has_key?('pagination')
    end

    def pagination
      return nil unless pagination?
      parsed_response['meta']['pagination']
    end

    def error?
      parsed_response
      @error.present?
    end

    def error
      parsed_response
      @error
    end

    private

    def parsed_response
      @parsed_response ||= JSON.parse(@response)
    rescue JSON::ParserError => e
      @error = e.message
    end

  end
end
