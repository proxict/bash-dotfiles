System-Wide Configuration For Bash
==================================

To install it, clone this repo to `/etc/bash` and create a symlink `/etc/bash.bashrc` pointing to `/etc/bash/bash.bashrc`:
```bash
# Usually, you'll need to use root privileges to perform these actions
git clone https://github.com/proxict/bash-dotfiles.git /etc/bash
mv /etc/bash.bashrc /etc/bash.bashrc.backup
ln -s /etc/bash/bash.bashrc /etc/bash.bashrc
```
Also, if you already have a `~/.bashrc` file, make sure nothing colides with the one in `/etc/bash.bashrc`.

All these files will be sourced from your home directory if they exist:
```
~/.bashrc
~/.bash_aliases
~/.bash_globals
~/.profile
~/.bash_profile
```

