module DJing360
  module API
    class Base
      def initialize(client)
        @client = client
      end

      def method_missing(name, params:{}, headers:{})
        uri = name.to_s.split('_').each_with_index.map{|k, i| (i > 0) ? k.capitalize : k}.join("")
       
        headers.merge({
          :apiKey => @client.oauth2.id,
          :accessToken => @client.token.token,
          :serveToken => Time.now.to_i.to_s,
          :format => 'json'
        })

        params.merge({
          :format => 'json'
        })

        puts _build_uri_path(uri)
        puts @client.oauth2.site

        @client.token.get(_build_uri_path(uri), 
          :headers => headers,
          :params => params,
        )
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
