module ContentNetwork
  class EntriesFetcher
    def initialize(path_params = {}, pagination_params = {})
      @path_params = PathParams.build(path_params)
      @pagination_params = PaginationParams.build(pagination_params)
    end

    def fetch
      response = execute_query
      Collection.new(response.body)
    end

    private

    def execute_query
      uri = build_uri
      uri.query = build_query
      Net::HTTP.get_response(uri)
    end

    def build_query
      URI.encode_www_form(@pagination_params.to_h)
    end

    def build_uri
      path = @path_params.path
      URI.join(ContentNetwork.base_uri, path)
    end
  end
end
