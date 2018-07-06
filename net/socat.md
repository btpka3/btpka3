

## echo server

```bash
# server
socat -v tcp-l:1234,fork exec:'/bin/cat'

# client
nc serverip 1234
```
