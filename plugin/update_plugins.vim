" Author: Evan Gray
" Plugin: UpdatePlugins
" Description: Plugin to update git repo plugins
" Date: October 2017

if exists('g:update_plugins_is_loaded') || &cp
  finish
elseif v:version < 700
  echomsg 'UpdatePlugins: Vim version [' . v:version . '] not supported.'
  finish
endif
let g:update_plugins_is_loaded = 1

if !exists('g:update_plugins_print_results')
  let g:update_plugins_print_results = 1
endif

if !exists('g:update_plugins_exclude')
  let g:update_plugins_exclude = []
endif

if !exists('g:update_plugins_git_command')
  let g:update_plugins_git_command =
        \ 'git checkout master && git pull origin master'
endif

if !exists('g:update_plugins_directory')
  if isdirectory($HOME . '/.vim/pack/')
    let g:update_plugins_directory = $HOME . '/.vim/pack/*/{start,opt}/'
  elseif isdirectory($HOME . '/.vim/bundle/')
    let g:update_plugins_directory = $HOME . '/.vim/bundle/'
  else
    echomsg 'UpdatePlugins: Cound not find a valid plugin directory!'
    finish
  endif
endif

command! ListAllPlugins call update_plugins#ListAllPlugins()
command! -bang UpdateAllPlugins call update_plugins#UpdateAllPlugins(<bang>0)
command! -bang -nargs=1 -complete=customlist,update_plugins#Completion UpdateSinglePlugin call update_plugins#UpdateSinglePlugin(<bang>0, <f-args>)

