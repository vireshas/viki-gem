module Viki
  class Client
    module Featured

      def featured(params = { })
        # hack because API is not returning the API error message
        raise Viki::Error, "A watchable_in parameter is required when using the platform parameter" if params[:platform] && !params[:watchable_in]
        response = request('/featured', params)
        results = []
        response["response"].each { |res| results << FeatureItem.new(res) }
        results
      end
    end
  end
end
