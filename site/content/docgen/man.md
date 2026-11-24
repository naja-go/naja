# Generating Man Pages for a naja.Command

Generate man pages from a Naja command:

```go
package main

import (
	"log"

	"github.com/naja-go/naja"
	"github.com/naja-go/naja/doc"
)

func main() {
	cmd := &naja.Command{
		Use:   "test",
		Short: "my test program",
	}
	header := &doc.GenManHeader{
		Title: "MINE",
		Section: "3",
	}
	err := doc.GenManTree(cmd, header, "/tmp")
	if err != nil {
		log.Fatal(err)
	}
}
```

That will get you a man page `/tmp/test.3`
