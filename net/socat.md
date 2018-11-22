

## echo server

```bash
# server
socat -v tcp-l:1234,fork exec:'/bin/cat'

# client
nc serverip 1234

nc 127.0.0.1 1234
echo "foo" > /dev/tcp/127.0.0.1/1234
```
