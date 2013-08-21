require 'oauth2'

module DJing360
  class Client
    attr_reader :oauth2, :token, :api_site, :api_version, :redirect_uri

    def initialize(client_id:nil, client_secret:nil, 
                   redirect_uri:'oob', 
                   access_token:'', 
                   oauth2_site:'https://openapi.360.cn', 
                   api_site:'https://api.e.360.cn', 
                   api_version:'1.0')


      @api_version = api_version
      @api_site = api_site
      @redirect_uri = redirect_uri
      @oauth2 = OAuth2::Client.new(client_id, client_secret,
        :site => oauth2_site,
        :authorize_url => '/oauth2/authorize',
        :token_url => '/oauth2/access_token',
        :ssl => {:verify => false},
        )

      if !access_token.nil? and !access_token.empty?
        @oauth2.site = @api_site
        @token = OAuth2::AccessToken.new(@oauth2, access_token)
      end
    end

    def authorize_url(redirect_uri:'oob', scope:'basic', display:'default')
      @redirect_uri = redirect_uri unless redirect_uri.empty?
      @oauth2.auth_code.authorize_url(:redirect_uri => @redirect_uri, :scope => scope, :display => display)
    end

    def get_token(code, redirect_uri:'oob')
      @redirect_uri = redirect_uri unless redirect_uri.empty?
      @token = @oauth2.auth_code.get_token(code, :redirect_uri => @redirect_uri)
    end

    def method_missing(name, params:{}, headers:{})
      cls = name.methods
      puts cls

      uri = name.to_s.split('_').map{ |k| k.capitalize}.join("")
     
      headers.merge({
        :apiKey => @oauth2.id,
        :accessToken => @token.token,
        :serveToken => Time.now.to_i.to_s,
        })

      params.merge({
        :format => 'json'
      })

      @token.get(_build_uri_path(uri), 
        :headers => headers,
        :params => params,
      )
    end


    private
      def _build_uri_path(uri)
        "#{@api_version}/#{uri}"
      end
  end
end