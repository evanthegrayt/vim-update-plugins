# Update Plugins (vim)
Easily update `vim` plugins with `git`.

### About
I recently had an itch to learn something new, so I decided to try some
vimscript. I'm aware that (better) plugins like this exist; it was more of a
learning experience for me, but it does work!

This plugin is compatible with `vim-8`, and its "new" `packages` directory
structure (`~/.vim/pack/*/{start,opt}/*/`), but still supports the old "standard"
`bundle` directory structure (`~/.vim/bundle/`). This directory, and a few other
things, are customizable.

## Installation
Please note, the current version works with unix-like operating systems. None of
this has been tested on Windows.

Since this plugin is for updating other plugins from `git` repositories, I
assume you're either running `vim-8` with the `packages` feature, or using
at least `vim-7` (including `vim-8`) with something like
[pathogen](https://github.com/tpope/vim-pathogen).

### vim-8 + Packages
To install with `vim-8`, using the `packages` feature.

```bash
mkdir -p ~/.vim/pack/evanthegrayt/start/
git clone https://github.com/evanthegrayt/vim-update-plugins.git \
    ~/.vim/pack/evanthegrayt/start/vim-update-plugins
```

### Pathogen
To install using pathogen:

```bash
git clone https://github.com/evanthegrayt/vim-update-plugins.git \
    ~/.vim/bundle/vim-update-plugins
```

## Features
This plugin attempts to update your `vim` plugins, either one at a time using
`:UpdateSinglePlugin [PLUGIN]`, or all at once using `:UpdateAllPlugins`. To use
the former, for now, you must specify the directory name of the plugin. To see
a list of available plugins, use `:ListAllPlugins`.

If you're running version 8 or higher, it will first look in
`~/.vim/pack/*/{start,opt}/`. If you're running version 7 or higher, or you're not
using the `pack` directory structure, it will look in `~/.vim/bundle/`. You are
able to set a custom directory if yours is in a different location.

You can create a list of plugins to exclude from updating. Calling either of the
Update commands with a bang (!) will ignore the exclusion list.

Once finished, the plugin will `echom` the results. You are able to turn this
off if you don't like the output.

## Configuration
If you don't like the default behavior, there are some modifications available.

### Plugin Directory Location
To manually set the location of your plugin directory, add the following line to
your `~/.vimrc`:

```vim
let g:update_plugins_directory = '/full/path/to/directory/'
```

If you're using a `pack`-like directory with sub-directories, use the `*`
wildcard. The `vim-8` example for Mac would be (and is, by default):
`$HOME/.vim/pack/*/{start,opt}/`

### Excluding Plugins
By default, the plugin attempts to update all plugins. If there are plugins
that you don't want updated, you can create a list of plugins to skip.

Please note that the list elements must match the directory name of the plugin.
Also note that calling `:UpdateSinglePlugin!` and `:UpdateAllPlugins!` (with the
bang) will ignore this list!

```vim
let g:update_plugins_exclude = ['plugin_to_exclude', 'second_plugin_to_exclude']
```

### Pulling from Git
The default command this plugin uses to update repositories is:

```bash
git checkout master && git pull origin master
```

The plugin allows you to change this command. For example, you can add the
following line to your `~/.vimrc`:

```vim
let g:update_plugins_git_command = 'git pull && git submodule update --init --recursive'
```

### Commands
If you do not like the default commands, you can create your own command names.
For example, you could add the following lines to your `~/.vimrc`:

```vim
command! PlugList call update_plugins#ListAllPlugins()
command! -bang PlugUpdateAll call update_plugins#UpdateAllPlugins(<bang>0)
command! -nargs=1 PlugUpdate call update_plugins#UpdateSinglePlugin(<bang>0, '<args>')

```

### Messages
To turn off the messages list once the plugin is finished, add the following
line to your `~/.vimrc`:

```vim
let g:update_plugins_print_results = 0
```

## Bugs
My latest version doesn't seem have this bug, but the first version had an issue
where, if the user pushed `ctrl-c`, the buffer would need to be redrawn. If this
somehow happens to you, you can use `:redraw!` to fix it.

## Contributing
This is just a little project I'm working on; I don't really expect people to
use it or contribute, but if you're bored, you're more than welcome to help
with issues or make suggestions.

## Self-Promotion
I do these projects for fun, and I enjoy knowing that they're helpful to people.
Consider starring [the
repository](https://github.com/evanthegrayt/vim-update-plugins) if you like it!
If you love it, follow me [on github](https://github.com/evanthegrayt)!
