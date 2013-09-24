require 'oauth2'

module Qihu
  class Auth
    attr_reader :oauth2, :access_token, :refresh_token, :expires_at, :expires_in
    attr_accessor :token, :redirect_uri

    def initialize(client_id, client_secret, token={}, redirect_uri='oob', site='https://openapi.360.cn')
      @redirect_uri = redirect_uri
      @oauth2 = OAuth2::Client.new(client_id, client_secret,
        :site => site,
        :authorize_url => '/oauth2/authorize',
        :token_url => '/oauth2/access_token',
        :ssl => {:verify => false},
      )

      if token or !token.empty?
        @token = OAuth2::AccessToken.from_hash(@oauth2, token)
      end
    end

    def authorize_url(options={})
      @redirect_uri = options[:redirect_uri] if options[:redirect_uri]
      scope = options[:scope] ? options[:scope] : 'basic'
      display = options[:display] ? options[:display] : 'default'

      @oauth2.auth_code.authorize_url(:redirect_uri => @redirect_uri, :scope => scope, :display => display)
    end

    def get_token(code, redirect_uri='')
      @redirect_uri = redirect_uri unless redirect_uri.empty?
      @token = @oauth2.auth_code.get_token(code, :redirect_uri => @redirect_uri)

      @refresh_token = @token.refresh_token
      @expires_at = @token.expires_at
      @expires_in = @token.expires_in
      @access_token = @token.token

      return self
    end

    def get_token_from_hash(token={})
      @token = OAuth2::AccessToken.from_hash(@oauth2, token)
      return self
    end

    def refresh_token
      @token.refresh!
    end
  end
end
