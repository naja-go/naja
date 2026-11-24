# Generating ReStructured Text Docs for a naja.Command

Generate ReST pages from a Naja command:

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
	err := doc.GenReSTTree(cmd, "/tmp")
	if err != nil {
		log.Fatal(err)
	}
}
```

That will get you a ReST document `/tmp/test.rst`

## Generate ReST docs for the entire command tree

Call `doc.GenReSTTree` with the root command after adding its subcommands.
It generates one file per command in the specified directory.

## Generate ReST docs for a single command

You may wish to have more control over the output, or only generate for a single command, instead of the entire command tree. If this is the case you may prefer to `GenReST` instead of `GenReSTTree`

```go
	out := new(bytes.Buffer)
	err := doc.GenReST(cmd, out)
	if err != nil {
		log.Fatal(err)
	}
```

This will write the ReST doc for ONLY "cmd" into the out, buffer.

## Customize the output

Both `GenReST` and `GenReSTTree` have alternate versions with callbacks to get some control of the output:

```go
func GenReSTTreeCustom(cmd *Command, dir string, filePrepender func(string) string, linkHandler func(string, string) string) error {
	//...
}
```

```go
func GenReSTCustom(cmd *Command, out *bytes.Buffer, linkHandler func(string, string) string) error {
	//...
}
```

The `filePrepender` will prepend the return value given the full filepath to the rendered ReST file. A common use case is to add front matter to use the generated documentation with [Hugo](https://gohugo.io/):

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

The `linkHandler` can be used to customize the rendered links to the commands, given a command name and reference. This is useful while converting rst to html or while generating documentation with tools like Sphinx where `:ref:` is used:

```go
// Sphinx cross-referencing format
linkHandler := func(name, ref string) string {
    return fmt.Sprintf(":ref:`%s <%s>`", name, ref)
}
```
