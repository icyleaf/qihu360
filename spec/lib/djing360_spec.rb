require 'spec_helper'

describe DJing360::Client do
  client_id     = ""
  client_secret = ""
  # pending "add some examples to (or delete)"

  subject do
    DJing360::Client.new(client_id:client_id, client_secret:client_secret)
  end

  describe "#initialize" do
    it "assigns oauth client id and secret" do
      expect(subject.oauth2.id).to eq(client_id)
      expect(subject.oauth2.secret).to eq(client_secret)
    end

    it "assigns oauth2 site" do
      expect(subject.oauth2.site).to eq('https://openapi.360.cn')
    end

    it "assigns api version and site" do
      expect(subject.api_version).to eq('1.0')
      expect(subject.api_site).to eq('https://api.e.360.cn')
    end

    it "is settable via the api version and site options" do
      subject.api_version = '2.0'
      expect(subject.api_version).to eq("2.0")

      subject.api_site = "http://api.360.cn"
      expect(subject.api_site).to eq("http://api.360.cn")
    end

    it "assigns redirect uri" do
      expect(subject.redirect_uri).to eq('oob')
    end

    it "is settable via the redirect uri option" do
      subject.redirect_uri = "http://icyleaf.com"
      expect(subject.redirect_uri).to eq("http://icyleaf.com")
    end

    it "assigns ssl verify to false" do
      expect(subject.oauth2.connection.ssl).to eq({:verify => false})
    end
  end

  describe "#authorize" do
    it "defaults to a path of /oauth2/authorize" do
      expect(subject.authorize_url).to match("https://openapi.360.cn/oauth2/authorize")
    end

    it "is settable authorize_url options" do
      expect(subject.authorize_url :display => 'desktop').to match('display=desktop')
      expect(subject.authorize_url :scope => 'all').to match('scope=all')
      expect(subject.authorize_url :redirect_uri => 'icyleaf.com').to match('redirect_uri=icyleaf.com')
    end
  end
end
