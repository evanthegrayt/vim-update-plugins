# update-plugins
Easily update vim plugins. I was bored recently, and decided to learn vimscript.
This is the first plugin I've made, so apologies if it's crude. Also, I'm aware
that plugins like this exist; it was more of a learning experience for me.

## Features
Updates all plugins in your `vim` plugin directory. If you're running version 8
or higher, it will first look in `~/.vim/pack/*/start/*`. If you're running
version 7 or higher, it will look in `~/.vim/bundle/*`

## Mappings
By default, you start the process by using `:UpdatePlugins`. You can also create
your own mapping. For example: `nnoremap <leader>UP :call g:UpdatePlugins()<CR>`

## In The Works...
Need to add a global variable that can allow the user to manually set the
location of the plugin directory. Trying to determine the best way to do this...

