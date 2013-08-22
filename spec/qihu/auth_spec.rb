require 'spec_helper'

describe Qihu::Auth do
  client_id     = ""
  client_secret = ""

  subject do
    Qihu::Auth.new(client_id, client_secret)
  end

  describe "#初始化" do
    it "检查 OAuth2 client id 和 secret" do
      expect(subject.oauth2.id).to eq(client_id)
      expect(subject.oauth2.secret).to eq(client_secret)
    end

    it "检查 OAuth2 域名" do
      expect(subject.oauth2.site).to eq('https://openapi.360.cn')
    end

    it "检查 redirect_uri" do
      expect(subject.redirect_uri).to eq('oob')
    end

    it "是否可以设置 redirect_uri" do
      subject.redirect_uri = "http://icyleaf.com"
      expect(subject.redirect_uri).to eq("http://icyleaf.com")
    end

    it "是否关闭了 ssl 的验证" do
      expect(subject.oauth2.connection.ssl).to eq({:verify => false})
    end
  end

  describe "#验证" do
    it "检查默认的 /oauth2/authorize 路径" do
      expect(subject.authorize_url).to match("https://openapi.360.cn/oauth2/authorize")
    end

    it "是否可以设置 authorize_url" do
      expect(subject.authorize_url :display => 'desktop').to match('display=desktop')
      expect(subject.authorize_url :scope => 'all').to match('scope=all')
      expect(subject.authorize_url :redirect_uri => 'icyleaf.com').to match('redirect_uri=icyleaf.com')
    end
  end

end
