
[sdkman](https://sdkman.io/install)

# install
```shell
curl -s "https://get.sdkman.io" | bash
```

# configuration

vi ~/.sdkman/etc/config

```
sdkman_auto_answer=false
sdkman_selfupdate_feature=true
sdkman_insecure_ssl=true
sdkman_curl_connect_timeout=7
sdkman_curl_continue=true
sdkman_curl_max_time=10
sdkman_beta_channel=false
sdkman_debug_mode=false
sdkman_colour_enable=true
sdkman_auto_env=true
sdkman_rosetta2_compatible=true
sdkman_auto_complete=true 
sdkman_auto_selfupdate=true
sdkman_auto_update=true
sdkman_checksum_enable=true
```

# 代理

```shell
export http_proxy=socks5h://127.0.01:13659
export https_proxy=socks5h://127.0.01:13659
```