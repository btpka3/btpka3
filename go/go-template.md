
- go: [template](https://pkg.go.dev/text/template)
- [sprig](https://masterminds.github.io/sprig/) : Useful template functions for Go templates.




# hello world



```bash
mkdir /tmp/1/
cd /tmp/1/
go mod init example/hello
go get github.com/Masterminds/sprig/v3

# 准备 go 文件 a.go
GO_FILE=a.go
cat > ${GO_FILE} <<EOF
package main
import (
    "bytes"
	"log"
	//"os"
	"text/template"
    "github.com/Masterminds/sprig/v3"
)
func main() {
    type Inventory struct {
        Material string
        Count    uint
    }
    sweaters := Inventory{"Wool", 17}
    tmpl, err := template.New("test").Funcs(sprig.FuncMap()).Parse("{{.Count}} items are made of {{.Material | lower}}")
    if err != nil { panic(err) }
    buf := new(bytes.Buffer)
    err = tmpl.Execute(buf, sweaters)
    if err != nil { panic(err) }
    log.Println(buf.String())
    log.Println("Done.")
}
EOF

# 运行
go run ${GO_FILE}
```



