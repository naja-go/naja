# Naja

Naja is a Go library for building command-line applications and a hard fork of
[Cobra](https://github.com/spf13/cobra).

[![Test](https://github.com/naja-go/naja/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/naja-go/naja/actions/workflows/test.yml)
[![Go Reference](https://pkg.go.dev/badge/github.com/naja-go/naja.svg)](https://pkg.go.dev/github.com/naja-go/naja)
[![Go Report Card](https://goreportcard.com/badge/github.com/naja-go/naja)](https://goreportcard.com/report/github.com/naja-go/naja)

# Overview

Naja helps build CLIs with subcommands, like `git` and `go`.

Naja provides:
* Easy subcommand-based CLIs: `app server`, `app fetch`, etc.
* Fully POSIX-compliant flags (including short & long versions)
* Nested subcommands
* Global, local and cascading flags
* Intelligent suggestions (`app srver`... did you mean `app server`?)
* Automatic help generation for commands and flags
* Grouping help for subcommands
* Automatic help flag recognition of `-h`, `--help`, etc.
* Automatically generated shell autocomplete for your application (bash, zsh, fish, powershell)
* Automatically generated man pages for your application
* Command aliases so you can change things without breaking them
* The flexibility to define your own help, usage, etc.
* Optional seamless integration with [viper](https://github.com/spf13/viper) for 12-factor apps

# Concepts

Naja is built on a structure of commands, arguments & flags.

**Commands** represent actions, **Args** are things and **Flags** are modifiers for those actions.

The best applications read like sentences when used, and as a result, users
intuitively know how to interact with them.

The pattern to follow is
`APPNAME VERB NOUN --ADJECTIVE`
    or
`APPNAME COMMAND ARG --FLAG`.

A few good real world examples may better illustrate this point.

In the following example, 'server' is a command, and 'port' is a flag:

    hugo server --port=1313

In this command we are telling Git to clone the url bare.

    git clone URL --bare

## Commands

Command is the central point of the application. Each interaction that
the application supports will be contained in a Command. A command can
have children commands and optionally run an action.

In the example above, 'server' is the command.

[More about naja.Command](https://pkg.go.dev/github.com/naja-go/naja#Command)

## Flags

A flag is a way to modify the behavior of a command. Naja supports
fully POSIX-compliant flags as well as the Go [flag package](https://golang.org/pkg/flag/).
A Naja command can define flags that persist through to children commands
and flags that are only available to that command.

In the example above, 'port' is the flag.

Flag functionality is provided by the [pflag
library](https://github.com/spf13/pflag), a fork of the flag standard library
which maintains the same interface while adding POSIX compliance.

# Installing

Naja requires Go 1.27 or newer.

```sh
go get github.com/naja-go/naja@main
```

Then import `github.com/naja-go/naja` as package `naja`. If you generate
documentation, import `github.com/naja-go/naja/doc` as package `doc`.

# Usage

See the [user guide](site/content/user_guide.md) to build your first command.
If you're migrating from Cobra, update both import paths and change references
such as `cobra.Command` to `naja.Command`.

# License

Naja is released under the Apache 2.0 license. See [LICENSE.txt](LICENSE.txt).
