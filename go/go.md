

- [golang](https://go.dev/doc/tutorial/getting-started)
- [pkg.go.dev](https://pkg.go.dev/)
- [Go (Golang) GOOS and GOARCH](https://gist.github.com/asukakenji/f15ba7e588ac42795f421b48b8aede63)

```shell
mkdir /tmp/1/
cd /tmp/1/

go mod init example/hello
cat > hello.go <<EOF
package main

import "fmt"
import "rsc.io/quote"

func main() {
    fmt.Println(quote.Go())
}
EOF

go mod tidy
go run .

# 构建当前系统的可执行程序
go build
file hello
./hello

# 跨平台构建

env GOOS=linux GOARCH=amd64 go build -o hello-linux-amd64
file hello-linux-amd64

env GOOS=linux GOARCH=arm64 go build -o hello-linux-arm64
file hello-linux-arm64

env GOOS=windows GOARCH=amd64 go build -o hello-windows-arm64.exe
file hello-windows-arm64.exe
```
