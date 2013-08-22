require 'oauth2'

module DJing360
  class Client
    attr_reader :oauth2, :token
    attr_accessor :api_version, :api_site, :redirect_uri

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
        @token = _get_api_token(access_token)
      end
    end

    def authorize_url(redirect_uri:'', scope:'basic', display:'default')
      @redirect_uri = redirect_uri unless redirect_uri.empty?
      @oauth2.auth_code.authorize_url(:redirect_uri => @redirect_uri, :scope => scope, :display => display)
    end

    def get_token(code, redirect_uri:'')
      @redirect_uri = redirect_uri unless redirect_uri.empty?
      @token = @oauth2.auth_code.get_token(code, :redirect_uri => @redirect_uri)

      @token = _get_api_token(@token.token)
    end

    def account
      @account ||= DJing360::API::Account.new(self)
    end

    def campaign
      @campaign ||= DJing360::API::Campaign.new(self)
    end

    def group
      
    end

    def creative
      
    end

    def keyword
      
    end

    def report
      
    end

    def tool
      
    end

    private
      def _get_api_token(access_token)
        @oauth2.site = @api_site
        @token = OAuth2::AccessToken.new(@oauth2, access_token)
      end
  end
end