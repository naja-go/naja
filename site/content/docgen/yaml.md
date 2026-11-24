# Generating YAML Docs for a naja.Command

Generate YAML files from a Naja command:

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
	err := doc.GenYamlTree(cmd, "/tmp")
	if err != nil {
		log.Fatal(err)
	}
}
```

That will get you a Yaml document `/tmp/test.yaml`

## Generate yaml docs for the entire command tree

Call `doc.GenYamlTree` with the root command after adding its subcommands.
It generates one file per command in the specified directory.

## Generate yaml docs for a single command

You may wish to have more control over the output, or only generate for a single command, instead of the entire command tree. If this is the case you may prefer to `GenYaml` instead of `GenYamlTree`

```go
	out := new(bytes.Buffer)
	doc.GenYaml(cmd, out)
```

This will write the yaml doc for ONLY "cmd" into the out, buffer.

## Customize the output

Both `GenYaml` and `GenYamlTree` have alternate versions with callbacks to get some control of the output:

```go
func GenYamlTreeCustom(cmd *Command, dir string, filePrepender, linkHandler func(string) string) error {
	//...
}
```

```go
func GenYamlCustom(cmd *Command, out *bytes.Buffer, linkHandler func(string) string) error {
	//...
}
```

The `filePrepender` will prepend the return value given the full filepath to the rendered Yaml file. A common use case is to add front matter to use the generated documentation with [Hugo](https://gohugo.io/):

```go
const fmTemplate = `---
date: %s
title: "%s"
slug: %s
url: %s
---
`

filePrepender := func(filename string) string {
	now := time.Now().Format(time.RFC3339)
	name := filepath.Base(filename)
	base := strings.TrimSuffix(name, path.Ext(name))
	url := "/commands/" + strings.ToLower(base) + "/"
	return fmt.Sprintf(fmTemplate, now, strings.Replace(base, "_", " ", -1), base, url)
}
```

The `linkHandler` can be used to customize the rendered internal links to the commands, given a filename:

```go
linkHandler := func(name string) string {
	base := strings.TrimSuffix(name, path.Ext(name))
	return "/commands/" + strings.ToLower(base) + "/"
}
```
