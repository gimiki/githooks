## git hooks update

Performs an update check.

### Synopsis


Executes an update check for a newer Githooks version.

If it finds one and the user accepts the prompt (or `--yes` is used)
the installer is executed to update to the latest version.

The `--enable` and `--disable` options enable or disable
the automatic checks that would normally run daily
after a successful commit event.

```
git hooks update
```

### Options

```
      --disable   Disable daily Githooks update checks.
      --enable    Enable daily Githooks update checks.
  -h, --help      help for update
      --no        Always deny an update and only check for it.
      --yes       Always accepts a new update (non-interactive).
```

### SEE ALSO

* [git hooks](git_hooks.md)	 - Githooks CLI application

###### Auto generated by spf13/cobra on 11-Jan-2021