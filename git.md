# install gitlab
see [here](https://github.com/gitlabhq/gitlabhq/blob/master/doc/install/installation.md)


# first login
```sh
su - git
cd /home/git/gitlab
bundle exec rake db:seed_fu RAILS_ENV=production
== Seed from /home/git/gitlab/db/fixtures/production/001_admin.rb
2014-03-26T06:51:38Z 13826 TID-aw08k INFO: Sidekiq client with redis options {:url=>"redis://localhost:6379", :namespace=>"resque:gitlab"}

Administrator account created:

login.........admin@local.host
password......5iveL!fe

```

# LDAP login

```sh
vi config/gitlab.yml
  ldap:
    enabled: true
    host: '10.1.10.2'
    port: 389
    uid: 'userPrincipalName' # "sAMAccountName"
    method: 'plain' # "tls" or "ssl" or "plain"
    bind_dn: 'CN=张亮亮,OU=研发中心,OU=信息事业部,OU=通策集团,DC=tcgroup,DC=local'
    password: 'ZLL password'
    allow_username_or_email_login: false
    base: 'DC=TCGROUP,DC=LOCAL'
    user_filter: '(objectCategory=CN=Person,CN=Schema,CN=Configuration,DC=tcgroup,DC=local)'

bundle exec rake gitlab:ldap:check RAILS_ENV=production
```
