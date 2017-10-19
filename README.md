# UpdatePlugins
Easily update vim plugins. I was bored recently, and decided to learn vimscript.
This is the first plugin I've made, so apologies if it's crude. Also, I'm aware
that plugins like this exist; it was more of a learning experience for me.

## Features
Attempts to update all plugins in your `vim` plugin directory.

If you're running version 8 or higher, it will first look in
`~/.vim/pack/*/start/*`. If you're running version 7 or higher, or you're not
using the `pack` directory structure, it will look in `~/.vim/bundle/*`.

Once finished, the plugin will `echom` the results. To turn this feature off,
see the `Variables` section below.

## Variables
To manually set the location of your plugin directory, add the following line to
your `~/.vimrc`:

```
let g:update_plugins_directory = '/full/path/to/directory/'
```

If you're using a `pack` directory with sub-directories, use the `*` wildcard.
The vim8 example for Mac would be (and is, by default):
`/Users/USER/.vim/pack/*/start/`.

To turn off the messages list once the pluginis finished, add the following line
to your `~/.vimrc`:

```
let g:update_plugins_print_results = 0`
```

## Mappings
By default, you start the process by using `:UpdatePlugins`. You can also create
your own mapping. For example: `nnoremap <leader>UP :call g:UpdatePlugins()<CR>`

