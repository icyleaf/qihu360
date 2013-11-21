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
            r = @client.auth.token.request(method, uri_path, :headers => client_headers, :params => params)

            if self.json?(r.headers)
              data = self.to_json(r.body)
            elsif self.xml?(r.headers)
              root = "#{self.url_section}_#{name}_response"
              data = self.to_xml(r.body)
              data = data[root]
            end

            if data.has_key?('failures')
              key = data['failures'].kind_of?(Hash) ? 'item' : 0
              code = data['failures'][key]['code'].to_i
              error = data['failures'][key]['message']

              raise Qihu::FailuresError.new(code, error)
            end

            return r
          rescue OAuth2::Error => e
            raise Qihu::InvailAPIError.new("#{@client.site}/#{uri_path}", e.message)
          end
        end

        protected
          # Convert response content to JSON format
          #
          # @return [Hash]
          def to_json(body)
            MultiJson.load(body)
          end

          # Convert response content to XML format
          #
          # @return [Hash]
          def to_xml(body, parser=nil)
            MultiXml.parser = p if parser and [:ox, :libxml, :nokogiri, :rexml].include?parser.to_sym
            MultiXml.parse(body)
          end

          # Whether or not the content is json content type
          #
          # @return [Boolean]
          def json?(headers)
            (headers[:content_type].include?'json') ? true : false
          end

          # Whether or not the content is xml content type
          #
          # @return [Boolean]
          def xml?(headers)
            (['xml', 'html'].any? { |word| headers[:content_type].include?(word) }) ? true : false
          end


          def client_headers
            {
              :apiKey => @client.auth.token.client.id,
              :accessToken => @client.auth.token.token,
              :serveToken => Time.now.to_i.to_s,
            }
          end

          def url_section
            self.class.name.split("::")[-1].downcase
          end

          def uri_path(uri)
            class_name = self.url_section
            "#{@client.version}/#{class_name}/#{uri}"
          end
      end
    end
  end
end