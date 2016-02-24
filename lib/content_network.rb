require 'content_network/path_params'
require 'content_network/pagination_params'
require 'content_network/collection'
require 'content_network/entries_fetcher'

module ContentNetwork
  def self.base_uri(uri = nil)
    if uri
      @base_uri = URI(uri)
    else
      @base_uri
    end
  end
end
