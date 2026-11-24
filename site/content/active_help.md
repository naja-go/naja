# Active Help

Active Help is a framework provided by Naja which allows a program to define messages (hints, warnings, etc) that will be printed during program usage.  It aims to make it easier for your users to learn how to use your program.  If configured by the program, Active Help is printed when the user triggers shell completion.

For example,

```console
$ helm repo add [tab]
You must choose a name for the repo you are adding.

$ bin/helm package [tab]
Please specify the path to the chart to package

$ bin/helm package [tab][tab]
bin/    internal/    scripts/    pkg/     testdata/
```

**Hint**: A good place to use Active Help messages is when the normal completion system does not provide any suggestions. In such cases, Active Help nicely supplements the normal shell completions to guide the user in knowing what is expected by the program.

## Supported shells

Active Help is currently only supported for the following shells:
- Bash (using [bash completion V2](completions/_index.md#bash-completion-v2) only). Note that bash 4.4 or higher is required for the prompt to appear when an Active Help message is printed.
- Zsh

## Adding Active Help messages

As Active Help uses the shell completion system, the implementation of Active Help messages is done by enhancing custom dynamic completions.  If you are not familiar with dynamic completions, please refer to [Shell Completions](completions/_index.md).

Adding Active Help is done through the use of the `naja.AppendActiveHelp(...)` function, where the program repeatedly adds Active Help messages to the list of completions.  Keep reading for details.

### Active Help for nouns

Adding Active Help when completing a noun is done within the `ValidArgsFunction(...)` of a command.  Notice the calls to `naja.AppendActiveHelp(...)` in the following example:

```go
cmd := &naja.Command{
	Use:   "add [NAME] [URL]",
	Short: "add a chart repository",
	Args:  naja.ExactArgs(2),
	RunE: func(cmd *naja.Command, args []string) error {
		return addRepo(args)
	},
	ValidArgsFunction: func(cmd *naja.Command, args []string, toComplete string) ([]naja.Completion, naja.ShellCompDirective) {
		var comps []naja.Completion
		if len(args) == 0 {
			comps = naja.AppendActiveHelp(comps, "You must choose a name for the repo you are adding")
		} else if len(args) == 1 {
			comps = naja.AppendActiveHelp(comps, "You must specify the URL for the repo you are adding")
		} else {
			comps = naja.AppendActiveHelp(comps, "This command does not take any more arguments")
		}
		return comps, naja.ShellCompDirectiveNoFileComp
	},
}
```

The example above defines the completions (none, in this specific example) as well as the Active Help messages for the `helm repo add` command.  It yields the following behavior:

```console
$ helm repo add [tab]
You must choose a name for the repo you are adding

$ helm repo add grafana [tab]
You must specify the URL for the repo you are adding

$ helm repo add grafana https://grafana.github.io/helm-charts [tab]
This command does not take any more arguments
```

**Hint**: As can be seen in the above example, a good place to use Active Help messages is when the normal completion system does not provide any suggestions. In such cases, Active Help nicely supplements the normal shell completions.

### Active Help for flags

Providing Active Help for flags is done in the same fashion as for nouns, but using the completion function registered for the flag.  For example:

```go
_ = cmd.RegisterFlagCompletionFunc("version", func(cmd *naja.Command, args []string, toComplete string) ([]naja.Completion, naja.ShellCompDirective) {
	if len(args) != 2 {
		return naja.AppendActiveHelp(nil, "You must first specify the chart to install before the --version flag can be completed"), naja.ShellCompDirectiveNoFileComp
	}
	return compVersionFlag(args[1], toComplete)
})
```
The example above prints an Active Help message when not enough information was given by the user to complete the `--version` flag.

```console
$ bin/helm install myrelease --version 2.0.[tab]
You must first specify the chart to install before the --version flag can be completed

$ bin/helm install myrelease bitnami/solr --version 2.0.[tab][tab]
2.0.1  2.0.2  2.0.3
```

## User control of Active Help

You may want to allow your users to disable Active Help or choose between different levels of Active Help.  It is entirely up to the program to define the type of configurability of Active Help that it wants to offer, if any.
Allowing to configure Active Help is entirely optional; you can use Active Help in your program without doing anything about Active Help configuration.

The way to configure Active Help is to use the program's Active Help environment
variable.  That variable is named `<PROGRAM>_ACTIVE_HELP` where `<PROGRAM>` is the name of your 
program in uppercase with any non-ASCII-alphanumeric characters replaced by an `_`.  The variable should be set by the user to whatever
Active Help configuration values are supported by the program.

For example, say `helm` has chosen to support three levels for Active Help: `on`, `off`, `local`.  Then a user
would set the desired behavior to `local` by doing `export HELM_ACTIVE_HELP=local` in their shell.

For simplicity, when in `cmd.ValidArgsFunction(...)` or a flag's completion function, the program should read the
Active Help configuration using the `naja.GetActiveHelpConfig(cmd)` function and select what Active Help messages
should or should not be added (instead of reading the environment variable directly).

For example:

```go
ValidArgsFunction: func(cmd *naja.Command, args []string, toComplete string) ([]naja.Completion, naja.ShellCompDirective) {
	activeHelpLevel := naja.GetActiveHelpConfig(cmd)

	var comps []naja.Completion
	if len(args) == 0 {
		if activeHelpLevel != "off" {
			comps = naja.AppendActiveHelp(comps, "You must choose a name for the repo you are adding")
		}
	} else if len(args) == 1 {
		if activeHelpLevel != "off" {
			comps = naja.AppendActiveHelp(comps, "You must specify the URL for the repo you are adding")
		}
	} else {
		if activeHelpLevel == "local" {
			comps = naja.AppendActiveHelp(comps, "This command does not take any more arguments")
		}
	}
	return comps, naja.ShellCompDirectiveNoFileComp
},
```

**Note 1**: If `<PROGRAM>_ACTIVE_HELP` is set to `0`, Naja disables all Active Help output, including messages added with `naja.AppendActiveHelp(...)`.

**Note 2**: To disable Active Help globally, set `COBRA_ACTIVE_HELP` to `0`. Naja retains this environment variable for compatibility. When set to `0`, `naja.GetActiveHelpConfig(cmd)` returns `0` regardless of `<PROGRAM>_ACTIVE_HELP`.

**Note 3**: If neither variable is set, `naja.GetActiveHelpConfig(cmd)` returns an empty string.

## Active Help with Naja's default completion command

Naja provides a default `completion` command for programs that wish to use it.
When using the default `completion` command, Active Help is configurable in the same
fashion as described above using environment variables.  You may wish to document this in more
details for your users.

## Debugging Active Help

Debugging your Active Help code is done in the same way as debugging your dynamic completion code, which is with Naja's hidden `__complete` command.  Please refer to [debugging shell completion](completions/_index.md#debugging) for details.

When debugging with the `__complete` command, if you want to specify different Active Help configurations, you should use the active help environment variable.  That variable is named `<PROGRAM>_ACTIVE_HELP` where any non-ASCII-alphanumeric characters are replaced by an `_`.  For example, we can test deactivating some Active Help as shown below:

```console
$ HELM_ACTIVE_HELP=1 bin/helm __complete install wordpress bitnami/h<ENTER>
bitnami/haproxy
bitnami/harbor
_activeHelp_ WARNING: cannot re-use a name that is still in use
:0
Completion ended with directive: ShellCompDirectiveDefault

$ HELM_ACTIVE_HELP=0 bin/helm __complete install wordpress bitnami/h<ENTER>
bitnami/haproxy
bitnami/harbor
:0
Completion ended with directive: ShellCompDirectiveDefault
```
