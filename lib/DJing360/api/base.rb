module DJing360
  module API
    class Base
      def initialize(client)
        @client = client
      end

      def method_missing(name, *args, &block)
        if name.match(/_/)
          name = name.to_s.split('_').each_with_index.map{|k, i| (i > 0) ? k.capitalize : k}.join("")
        end

        headers = {
          :apiKey => @client.oauth2.id,
          :accessToken => @client.token.token,
          :serveToken => Time.now.to_i.to_s,
        }

        params = {
          :format => 'json'
        }.merge(args[0])

        begin
          method = name.match(/^get/) ? :get : :post
          uri_path = _build_uri_path(name)
          @client.token.request(method, uri_path, :headers => headers, :params => params)
        rescue OAuth2::Error
          raise "Invaild API: #{@client.api_site}/#{uri_path}"
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
          "#{@client.api_version}/#{class_name}/#{uri}"
        end
    end
  end
end
