module DJing360
  module API
    class Base
      def initialize(client)
        @client = client
      end

      def method_missing(name, params:{}, headers:{})
        if name.match(/_/)
          name = name.to_s.split('_').each_with_index.map{|k, i| (i > 0) ? k.capitalize : k}.join("")
        end
        
        headers = {
          :apiKey => @client.oauth2.id,
          :accessToken => @client.token.token,
          :serveToken => Time.now.to_i.to_s,
        }.merge(headers)

        params = {
          :format => 'json'
        }.merge(params)

        if name.match(/^get/)
          @client.token.get(_build_uri_path(name), 
            :headers => headers,
            :params => params,
          )
        else
          @client.token.post(_build_uri_path(name), 
            :headers => headers,
            :params => params,
          )
        end
      end


      # The OAuth client_id and client_secret
      #
      # @return [Hash]
      def client_params
        {
          'client_id' => @client.id, 
          'client_secret' => @client.secret,
        }
      end

      protected
        def _build_uri_path(uri)
          class_name = self.class.name.split("::")[-1].downcase
          "/#{@client.api_version}/#{class_name}/#{uri}"
        end
    end
  end
end
