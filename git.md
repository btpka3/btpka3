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