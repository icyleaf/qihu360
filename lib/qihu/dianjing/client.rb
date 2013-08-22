require 'oauth2'

module Qihu
  module DianJing
    class Client
      attr_reader :auth
      attr_accessor :version, :site, :uri

      def initialize(auth, options={})
        @site = options[:site] ? options[:site] : 'https://api.e.360.cn'
        @version = options[:version] ? options[:version] : '1.0'

        if auth.is_a?(Qihu::Auth)
          auth.token.client.site = @site
          @auth = auth
        else
          raise 'auth must be "DianJing::Auth" instance.'
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
        @account ||= Qihu::DianJing::API::Account.new(self)
      end

      def campaign
        @campaign ||= Qihu::DianJing::API::Campaign.new(self)
      end

      def group
        @group ||= Qihu::DianJing::API::Group.new(self)
      end

      def creative
        @creative ||= Qihu::DianJing::API::Creative.new(self)
      end

      def keyword
        @keyword ||= Qihu::DianJing::API::Keyword.new(self)
      end

      def report
        @report ||= Qihu::DianJing::API::Report.new(self)
      end

      def tool
        @tool ||= Qihu::DianJing::API::Tool.new(self)
      end

      private
        def _get_api_token(access_token)
          @oauth2.site = @site
          @token = OAuth2::AccessToken.new(@oauth2, access_token)
        end
    end
  end
end