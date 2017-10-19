# UpdatePlugins (vim)
Easily update vim plugins. I was bored recently, and decided to learn vimscript.
This is the first plugin I've made, so apologies if it's crude. Also, I'm aware
that plugins like this exist; it was more of a learning experience for me.

This plugin is compatible with `Vim80`, and it's "new" `packages` directory
structure (`~/.vim/pack/*/start/*/`).

## Installation
Since this plugin is for updating other plugins from `git` repositories, I
assume you're either running `Vim80` with the `packages` feature, or using
`vim70` with something like `pathogen`. To install:
### Vim80 + Packages
To install with `Vim80` with `packages` (replace PLUGIN_DIRECTORY with the
package name)

```
cd ~/.vim/pack/PLUGIN_DIRECTORY/start/
git clone https://github.com/evanthegrayt/update-plugins.git
```

### Pathogen
To install using pathogen:

```
cd ~/.vim/bundle/
git clone https://github.com/evanthegrayt/update-plugins.git
```

## Quick Start
By default, you start the process by using `:UpdatePlugins`. You can also create
your own mapping. For example, you can add the following line to your `~/.vimrc`:

```
nnoremap <leader>up :call g:UpdatePlugins()<CR>
```

## Features
Attempts to update all plugins in your `vim` plugin directory.

If you're running version 8 or higher, it will first look in
`~/.vim/pack/*/start/*/`. If you're running version 7 or higher, or you're not
using the `pack` directory structure, it will look in `~/.vim/bundle/*/`

Once finished, the plugin will `echom` the results. To turn this feature off,
see the `Variables` section below.

## Variables
If you don't like the default behavior, there are soe modifications availale.
### Plugin Directory Location
To manually set the location of your plugin directory, add the following line to
your `~/.vimrc`:

```
let g:update_plugins_directory = '/full/path/to/directory/'
```

If you're using a `pack` directory with sub-directories, use the `*` wildcard.
The `Vim80` example for Mac would be (and is, by default):
`/Users/USER/.vim/pack/*/start/`

### Messages
To turn off the messages list once the plugin is finished, add the following
line to your `~/.vimrc`:

```
let g:update_plugins_print_results = 0
```

