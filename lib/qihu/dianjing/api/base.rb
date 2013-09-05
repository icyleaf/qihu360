module Qihu
  module DianJing
    module API
      class Base
        def initialize(client, options={})
          @client = client
        end

        def method_missing(name, *args, &block)
          if name.match(/_/)
            name = name.to_s.split('_').each_with_index.map{|k, i| (i > 0) ? k.capitalize : k}.join("")
          end

          params = {
            :format => 'json'
          }
          params = params.merge(args[0]) if args[0].is_a?(Hash)

          begin
            allowed_methods = [:get, :post, :put, :delete]
            if params.include?(:method)
              mehtod = params.delete(:method).downcase.to_sym
              method = :get unless allowed_methods.include?method
            else
              method = name.match(/^get/) ? :get : :post
            end

            uri_path = uri_path(name)
            @client.auth.token.request(method, uri_path, :headers => client_headers, :params => params)
          rescue OAuth2::Error => e
            raise "Invaild API: '#{@client.site}/#{uri_path}' with message:\n#{e.message}"
          end
        end

        protected
          def client_headers
            {
              :apiKey => @client.auth.token.client.id,
              :accessToken => @client.auth.token.token,
              :serveToken => Time.now.to_i.to_s,
            }
          end

          def uri_path(uri)
            class_name = self.class.name.split("::")[-1].downcase
            "#{@client.version}/#{class_name}/#{uri}"
          end
      end
    end
  end
end