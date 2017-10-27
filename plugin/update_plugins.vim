" Author: Evan Gray
" Plugin: UpdatePlugins
" Description: Plugin to update git repo plugins
" Date: October 2017

if exists('g:update_plugins_is_loaded')
  finish
elseif v:version < 700
  echomsg "UpdatePlugins: Vim version [ " . v:version . " not supported..."
  finish
endif
let g:update_plugins_is_loaded = 1

if !exists("g:update_plugins_print_results")
  let g:update_plugins_print_results = 1
endif

if !exists('g:update_plugins_git_command')
  let g:update_plugins_git_command =
        \ 'git pull && git submodule update --init --recursive'
endif

if !exists("g:update_plugins_directory")
  if v:version >= 800 && isdirectory($HOME . "/.vim/pack/")
    let g:update_plugins_directory = $HOME . '/.vim/pack/*/start/'
  elseif isdirectory($HOME . "/.vim/bundle/")
    let g:update_plugins_directory = $HOME . '/.vim/bundle/'
  else
    echomsg "UpdatePlugins: Cound not find a valid plugin directory!"
    finish
  endif
endif

if !exists("g:update_plugins_ignore")
  " TODO: add UpdateAllPlugins! command that ignores the ignore list
  let g:update_plugins_ignore = []
endif

command! ListAllPlugins call update_plugins#list_all_plugins()
command! UpdateAllPlugins call update_plugins#update_all_plugins()
command! -nargs=+ UpdateSinglePlugin
      \ call update_plugins#update_single_plugin('<args>')

