require 'oauth2'

module DianJing
  # The DianJing::Auth class
  class Auth
    attr_reader :oauth_client, :token, :redirect_uri

    def initialize(client_id, client_secret, redirect_uri='oob', site='https://openapi.360.cn')
      @redirect_uri = redirect_uri
      @oauth_client = OAuth2::Client.new(client_id, client_secret,
        :site => site,
        :authorize_url => '/oauth2/authorize',
        :token_url => '/oauth2/access_token',
        :ssl => {:verify => false},
      )
    end

    def authorize_url(*options)
      @redirect_uri = options[:redirect_uri] unless options[:redirect_uri].empty?
      scope = options[:scope] ? options[:scope] : 'basic'
      display = options[:display] ? options[:display] : 'default'

      @oauth_client.auth_code.authorize_url(:redirect_uri => @redirect_uri, :scope => scope, :display => display)
    end

    def get_client(code, redirect_uri='')
      @redirect_uri = redirect_uri unless redirect_uri.empty?
      @token = @oauth_client.auth_code.get_token(code, :redirect_uri => @redirect_uri)

      @token = _get_api_token(@token.token)

      @client ||= Dianjing::Client.new(token:token)
    end

    private
      def _get_api_token(access_token)
        @oauth_client.site = @api_site
        @token = OAuth2::AccessToken.new(@oauth_client, access_token)
      end
  end
end