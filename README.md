# dotfiles

## AI configuration

The scripts in `ai/` synchronize the AI configuration that is available on a
machine. Missing files and directories are skipped.

Install selected components with the interactive multi-select picker (fzf when
available):

```sh
./ai/install.sh
```

Install components by name, or install all components in this checkout:

```sh
./ai/install.sh agents vera
./ai/install.sh --all
```

Update the checkout from the configuration installed on the current machine:

```sh
./ai/update.sh
```

The update also derives `.config/herdr/plugins.txt` from Herdr's
`~/.config/herdr/plugins.json` when that metadata is available.

Available components are `agents`, `herdr`, `terminal-browser`, and `vera`.

## Application configuration

The scripts in `.config/` synchronize configuration for applications installed
on a machine. Missing files and directories are skipped.

Install selected components with the interactive multi-select picker:

```sh
./.config/install.sh
```

Install components by name, or install all components in this checkout:

```sh
./.config/install.sh astrovim yazi
./.config/install.sh --all
```

Update the checkout from the configuration installed on the current machine:

```sh
./.config/update.sh
```

Available components are `astrovim`, `ghostty`, `herdr`, `tuxedo`, and `yazi`.
AstroVim is installed as `~/.config/nvim`; Ghostty's `config.ghostty` is
tracked as `.config/ghostty/config`.
