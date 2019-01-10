### 编写hello world代码
```
package main
import "fmt"
func main() {
    fmt.Println("Hello World!")
}
```


### 运行hello world
```
➜  /tmp go run hello.go
Hello World!

```


### 编译为可执行程序
```
➜  thj go build hello.go
➜  thj ls
hello  hello.go
➜  thj ./hello
Hello World!
```
