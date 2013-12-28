## What OPTIONS is the running kernel using?
[See this](http://www.walkernews.net/2008/11/21/how-to-check-what-kernel-build-options-enabled-in-the-linux-kernel/):
```sh
cat /boot/config-$(uname -r)
```