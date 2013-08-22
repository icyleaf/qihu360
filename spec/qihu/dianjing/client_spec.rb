require 'spec_helper'

describe Qihu::DianJing::Client do
  client_id     = ""
  client_secret = ""
  access_token  = ""

  subject do
    auth = Qihu::Auth.new(client_id, client_secret, token={
      :access_token => access_token,
    })
    Qihu::DianJing::Client.new(auth)
  end

  describe "#初始化" do
    it "检查 api 版本和域名" do
      expect(subject.version).to eq('1.0')
      expect(subject.site).to eq('https://api.e.360.cn')
    end

    it "是否可以设置 api 版本和域名" do
      subject.version = '2.0'
      expect(subject.version).to eq("2.0")

      subject.site = "http://api.360.cn"
      expect(subject.site).to eq("http://api.360.cn")
    end
  end
end
