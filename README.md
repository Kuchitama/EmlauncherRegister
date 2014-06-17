# EmlauncherRegister

This gem is Web Application to register mail and password for [EMLauncher](https://github.com/KLab/emlauncher).
EMLauncher has no interface to register user's mail and password.
This gem provide the interface.
You can register your mail and password your self.

This application suppose running on AWS EC2.
Accesses to this application's port(default:8080) are controlled by EC2 SecurityGroup.

このgemはEMLauncherのユーザ認証にmailとpasswordを利用する際に、
新規ユーザの登録を行うためのWebApplicationです。
EMLauncherはmailとパスワードを登録するインタフェースを持っていませんが、
このgemを利用する事で利用者が自分でユーザ登録を出来るようになります。

基本的に、AWS EC2インスタンス上で動作する前提となっており、
このアプリが動作するポート(デフォルトでは8080番ポート)に対して、
SecurityGroupでアクセス制限を行う前提での実装となっています。


## Installation

1. Download gem from [here](https://github.com/Kuchitama/EmlauncherRegister/releases/)
2. install gem

    gem install emlaucher-register.1.0.0.gem

3. put json file of your configuration. you can copy and edit from [this](https://raw.githubusercontent.com/Kuchitama/EmlauncherRegister/master/config.json.sample).

4. run command below.

    emlaucher-register run {--port=YOUR_PORT} {--conf=YOUR_CONF_PATH}

5. browse https://YOUR_SERVER_HOST:8080/

### For Developer

1. clone from repository

    git clone https://github.com/kuchitama/emlauncher-register.git

2. into the source directory

    cd emlauncher-register

3. install dependency

    bundle install

4. run application

    bundle exec ruby bin/emlauncher-register run

5. browse https://localhost:8080/ from web browser


## Usage

You should prepare json file which written any configurations.

Json Fields is below. 


### EMLauncher Settings

field : `emlauncher`
type : Object

|Fields|Require|Type|Value|
|------|:-----:|----|-----|
|host| No | String | your emlauncher host name. |
|is_secure| No | Boolean | yoru emlauncher requires SSL access. If you provide ipa file to iOS7.1 or later, you must use SSL. | 

### Database Settings

field : `db`
type: Object

|Fields|Require|Type|Value|
|------|:-----:|----|-----|
|host | Yes | String | your host name of mysql. |
|username | Yes | String | mysql username. |
|password| Yes | String | mysql password. |
|database | Yes | String | mysql scheme name. |

### MailAddress Filters Settings

field : `address_filters`
type: List of String


#### Sample of Json
The json below is default EMlaucher settings.

```
{
   "emlauncher" : {
     "host" : "localhost",
     "is_secure" : false,
   },
   "db" : {
    "host" : "localhost",
    "username" : "emlauncher",
    "database" : "emlauncher",
    "password" : "xxxxxxxx",
  },
  "address_filters" : ["furyu.jp"]
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
