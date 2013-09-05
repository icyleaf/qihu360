# Qihu360

整合 `open.360.cn` 的一些业务 `Ruby` 封装。

- OAuth2 的封装
- 点睛营销平台(广告竞价排名系统) API 


## 安装

在你项目的 `Gemfile` 文件添加下行内容:

    gem 'qihu360'

保存后执行:

    $ bundle

或者直接执行下行命令安装:

    $ gem install qihu360


## 代码实例

### 验证 OAuth 2

    # 处理 oauth2
    auth = Qihu::Auth.new(id:'xxx', secret:'yyy')
    
    # 默认 redirect_uri 是 oob
    auth_url = auth.authorize_url() 

    # 设置回调网址和验证界面模式 
    auth_url = auth.authorize_url(redirect_uri:'http://icyleaf.com', display:'desktop')

    # 获取的 access token
    auth.get_token('code')


#### 使用 access token 初始化
  
  auth = Qihu::Auth.new(id:'xxx', secret:'yyy', token:{
      :access_token => 'zzz', :refresh_token => 'qqq', :expires_at => 36000
  })
  
  // 或者这样传递 access token
  auth.get_token_from_hash(:access_token => 'zzz', :refresh_token => 'qqq', :expires_at => 36000)

### 调用广告系统接口

    # 初始化必须传入获得 access token 的 Qihu::Auth 实例
    client = Qihu::DianJing::Client(auth)

    # 请求 account 的账户信息，默认返回 json 格式
    response = client.account.getInfo 
    # 除了驼峰调用模式，下划线同样适用
    response = client.account.get_info
    
    # 创建一个计划
    response = client.campign.add(name:'Beijing', budget:10000)
    
    # 更改提交的方法
    response = client.campign.add(name:'Beijing', bugget:20000, method:'get')

    # 获得返回信息
    status = response.status
    headers = response.headers
    body = response.body
    

## 贡献代码

1. Fork 本仓库
2. 创建你自己的 feature 分支 (`git checkout -b my-new-feature`)
3. 提交你的代码 (`git commit -am 'Add some feature'`)
4. 提交你的分支 (`git push origin my-new-feature`)
5. 创建一个新的 Pull Request
