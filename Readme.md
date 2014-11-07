Dotfiles and Config files VCS
=============================

uses [GNU `stow`](http://www.gnu.org/software/stow/).

#### Usage:

To install config files:
```sh
stow -vt ~ <PACKAGE>
```

To install config files, forcing overwrites (example of zsh flavours):
```sh
stow --override=.zshrc -vt ~ zsh.<flavour>
```

To uninstall config files:
```sh
stow -vDt ~ <PACKAGE>
```

#### Git Submodules

Initialise and update with:
```sh
git submodule update --init --recursive
```
