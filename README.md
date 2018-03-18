# Floop's Linux Environment

Are you tired of configuring your linux environment every time you launch a new VPS or reinstall your workstation?
Deploy Floop's environment and enjoy!

![screenshot](https://github.com/FloopCZ/linux-environment/raw/master/screenshot.png "Floop's environment screenshot")

## Deployment

```bash
git clone https://github.com/FloopCZ/linux-environment.git
cd linux-environment
./deploy.sh --install
```

If you are a Vim user, don't forget to run `:PlugInstall` inside Vim.

## Cheatsheet

__tmux__

| Shortcut         | Description                            |
| ---------------- | -------------------------------        |
| `Ctrl-b c`       | Create new window.                     |
| `Ctrl-b %`       | Split window horizontally.             |
| `Ctrl-b _`       | Split window vertically.               |
| `Ctrl-b x`       | Kill frozen pane.                      |
| `Alt-h/l`        | Move one window left/right.            |
| `Ctrl-h/j/k/l`   | Move one pane left/down/up/right.      |
| `Ctrl-b d`       | Detach current session.                |
| `tmux a`         | Reattach a detached session.           |

__vim__

To learn the basics of Vim, run the `vimtutor` command in your terminal.

| Shortcut         | Description                            |
| ---------------- | -------------------------------        |
| `:tabe <name>`   | Open existing/new file in a new tab.   |
| `Shift-h/l`      | Move one tab left/right.               |
| `:PlugInstall`   | Install all the registered plugins.    |

__zsh__

| Shortcut              | Description                                            |
| --------------------- | ------------------------------------------------------ |
| `Ctrl-space`          | Execute the suggested command.                         |
| `Ctrl-right arrrow`   | Accept one word of the suggested command.              |
| `Ctrl-c`              | Interrupt command.                                     |
| `Ctrl-f`              | Expand wildcards to the list of full names.            |
| `Ctrl-d`              | Exit shell.                                            |
| `rm`                  | Aliased to `trash` (use `trash-empty` to empty trash and `/bin/rm` for the real `rm`). |

__git__

To learn the basics of Git, try this [Git game](https://try.github.io).

| Shortcut              | Description                               |
| --------------------- | ----------------------------------------- |
| `gco`                 | `git checkout`                            |
| `gl`                  | `git pull`                                |
| `gp`                  | `git pull`                                |
| `gd`                  | `git diff`                                |
| `gst`                 | `git status`                              |
| `gb`                  | `git branch`                              |

For more Git shortcuts, see oh-my-zsh [git plugin wiki](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugin:git).
