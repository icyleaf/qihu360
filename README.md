# DJing360

360.cn 点睛营销平台(广告竞价排名系统) API `Ruby` 封装。

## 环境依赖

* Ruby 2.0

## 安装（暂无法使用）

Add this line to your application's Gemfile:

    gem 'DJing360'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install DJing360

## 代码实例

### 处理 OAuth 2

    # 处理 oauth2
    client = DJing360::Client.new(id:'xxx', secret:'yyy')
    
    # 默认 redirect_uri 是 oob
    auth_url = client.authorize_url() 

    # 设置回调网址和验证界面模式 
    auth_url = client.authorize_url(redirect_uri:'http://icyleaf.com', display:'desktop')

    # 获取的 access token
    client.get_token('code')

### 使用 access token 初始化

  client = DJing360::Client(id:'xxx', secret:'yyy', access_token:'zzz')

### 调用平台接口

    # 请求 account 的账户信息，默认返回 json 格式
    response = client.account.getInfo 
    # 除了驼峰调用模式，下划线同样适用
    response = client.account.get_info
    
    # 创建一个计划
    response = client.campign.add(name:'Beijing', budget:10000)

## 贡献代码

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
