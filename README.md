# UpdatePlugins (vim)
Easily update vim plugins.

### About

I recently had an itch to learn something new, so I decided to try some
vimscript. This is the first plugin I've made, so apologies if it's crude.
Also, I'm aware that (better) plugins like this exist; it was more of a
learning experience for me.

This plugin is compatible with `Vim80`, and its "new" `packages` directory
structure (`~/.vim/pack/*/start/*/`), but still supports the old "standard"
`bundle` directory structure (`~/.vim/bundle/`).

## Installation
Since this plugin is for updating other plugins from `git` repositories, I
assume you're either running `Vim80` with the `packages` feature, or using
at least `Vim70` (including `Vim80`) with something like
[pathogen](https://github.com/tpope/vim-pathogen).

### Vim80 + Packages
To install with `Vim80`, using the `packages` feature (replace
PACKAGE_DIRECTORY with the package name)

```bash
cd ~/.vim/pack/PACKAGE_DIRECTORY/start/
git clone https://github.com/evanthegrayt/update-plugins.git
```

### Pathogen
To install using pathogen:

```bash
cd ~/.vim/bundle/
git clone https://github.com/evanthegrayt/update-plugins.git
```

## Quick Start
By default, three commands are available:

```vim
:UpdateAllPlugins " Loop through all plugins and attempt to update them
:UpdateSinglePlugin [PLUGIN] " Attempt to update the specified [PLUGIN]
:ListAllPlugins " List all plugins, and whether or not they're a git repository
```

To change the default behavior, or to add custom mappings, see the
`Configuration` section below.

## Features
This plugin attempts to update your `vim` plugins, either one at a time using
`:UpdateSinglePlugin [PLUGIN]`, or all at once using `:UpdateAllPlugins`. To use
the former, for now, you must specify the directory name of the plugin. To see
a list of available plugins, use `:ListAllPlugins`. Also, for now, if you call
`:UpdateSinglePlugin` and the plugin is in your exclude list, it _will_ update
the plugin, since you called it by name. This 'feature' may change in the
future.

If you're running version 8 or higher, it will first look in
`~/.vim/pack/*/start/`. If you're running version 7 or higher, or you're not
using the `pack` directory structure, it will look in `~/.vim/bundle/`

Once finished, the plugin will `echom` the results. To turn this feature off,
see the `Configuration` section below.

## Configuration
If you don't like the default behavior, there are some modifications available.

### Plugin Directory Location
To manually set the location of your plugin directory, add the following line to
your `~/.vimrc`:

```vim
let g:update_plugins_directory = '/full/path/to/directory/'
```

If you're using a `pack`-like directory with sub-directories, use the `*`
wildcard. The `Vim80` example for Mac would be (and is, by default):
`/Users/$USER/.vim/pack/*/start/`

### Excluding Plugins
By default, the plugin attempts to update all plugins. If there are plugins
that you don't want updated, you can create a list of plugins to skip.
Please note that the list elements must match the directory name of the plugin.

```vim
let g:update_plugins_exclude = ['plugin_name']
```

### Pulling from Git
The default command this plugin uses to update repositories is:

```bash
git pull && git submodule update --init --recursive
```

The plugin allows you to change this command. For example, you can add the
following line to your `~/.vimrc`:

```vim
let g:update_plugins_git_command = 'git pull origin master'
```

### Mappings
If you do not like the default commands, you can create your own mappings. For
example, you can add the following lines to your `~/.vimrc`:

```vim
nnoremap <leader>uap :call update_plugins#update_all_plugins()<CR>
nnoremap <leader>usp :call update_plugins#update_single_plugin()<CR>
nnoremap <leader>lap :call update_plugins#list_all_plugins()<CR>
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

