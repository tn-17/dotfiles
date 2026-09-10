# dotfiles

## Unified synchronization

The root scripts provide one entrypoint for both configuration groups. The root
installer opens one picker containing AI and application components:

```sh
./install.sh
./install.sh --all
./update.sh
```

Use `ai` or `config` to operate on one group:

```sh
./install.sh ai agents vera
./install.sh config astrovim yazi
./update.sh ai
./update.sh config
```

The nested scripts remain available for direct group-specific use:

- `ai/install.sh` and `ai/update.sh`
- `.config/install.sh` and `.config/update.sh`

## AI configuration

The scripts in `ai/` synchronize the AI configuration that is available on a
machine. Missing files and directories are skipped. When a source directory
exists, updates mirror its contents and remove stale repository entries.

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

The update derives `ai/herdr/plugins.txt` from Herdr's
`${XDG_CONFIG_HOME:-~/.config}/herdr/plugins.json` when that metadata is
available. Each line contains the `OWNER/REPO` identifier consumed by
`herdr plugin install`; selecting the AI `herdr` component installs each
listed plugin with `--yes`.

Available components are `agents`, `herdr`, `terminal-browser`, and `vera`.

## Application configuration

The scripts in `.config/` synchronize configuration for applications installed
on a machine. Missing files and directories are skipped, existing source
directories are mirrored during updates, and `XDG_CONFIG_HOME` is honored
when set.

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
AstroVim is installed as `nvim` under the XDG config directory; Ghostty's
`config.ghostty` is tracked as `.config/ghostty/config.ghostty`.
