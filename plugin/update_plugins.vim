" update_plugins.vim
" Plugin to update git repo plugins
" Written by Evan Gray
" October 2017

if exists('g:update_plugins_is_loaded')
  finish
endif

let g:update_plugins_is_loaded = 1

if !exists("g:update_plugins_print_results")
  let g:update_plugins_print_results = 1
endif

if !exists("g:update_plugins_directory")
  let g:update_plugins_directory = update_plugins#set_directory()
endif

command! UpdatePlugins call update_plugins#start()

