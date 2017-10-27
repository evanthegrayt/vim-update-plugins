" Author: Evan Gray
" Plugin: UpdatePlugins
" Description: Plugin to update git repo plugins
" Date: October 2017

" PUBLIC API

function! update_plugins#update_all_plugins(bang)
  call s:create_arrays()
  let l:plugindirs = split(globpath(g:update_plugins_directory, '*', 0))
  call filter(l:plugindirs, 'isdirectory(v:val)')
  if empty(l:plugindirs)
    call s:warn("No valid directories found in [" . g:update_plugins_directory
          \ . ']')
    return
  endif
  for l:plugindir in l:plugindirs
    if !a:bang && s:is_excluded(fnamemodify(l:plugindir, ':t'))
      call add(s:excluded, fnamemodify(l:plugindir, ':t'))
    elseif !s:update(l:plugindir)
      call s:warn("Script was stopped before it was finished!")
      break
    endif
  endfor
  if g:update_plugins_print_results
    call s:print_results()
  else
    echo "Done..."
  endif
endfunction

function! update_plugins#update_single_plugin(bang, plugindir)
  call s:create_arrays()
  let l:plugindir = expand(g:update_plugins_directory . a:plugindir, 0)
  if !a:bang && s:is_excluded(a:plugindir)
    call s:warn("Directory " . a:plugindir . " excluded by user!")
  elseif isdirectory(l:plugindir)
    call s:update(l:plugindir)
    call s:print_results()
  else
    call s:warn(a:plugindir . " is not a directory!")
  endif
endfunction

function! update_plugins#list_all_plugins()
  call s:create_arrays()
  let l:plugindirs = split(globpath(g:update_plugins_directory, '*', 0))
  call filter(l:plugindirs, 'isdirectory(v:val)')
  for l:plugindir in l:plugindirs
    if s:is_excluded(fnamemodify(l:plugindir, ':t'))
      call add(s:excluded, fnamemodify(l:plugindir, ':t'))
    elseif isdirectory(l:plugindir . '/.git')
      call add(s:is_git, fnamemodify(l:plugindir, ':t'))
    else
      call add(s:not_git, fnamemodify(l:plugindir, ':t'))
    endif
  endfor
  call s:print_results()
endfunction

" PRIVATE API

function s:is_excluded(plugin)
  if !empty(g:update_plugins_exclude)
    for l:item in g:update_plugins_exclude
      if l:item ==? a:plugin | return 1 | endif
    endfor
  endif
  return 0
endfunction

function! s:update(plugindir)
  if isdirectory(a:plugindir . '/.git')
    echon "Updating " . a:plugindir . "\r"
    try
      let l:output = s:pull_from_git(a:plugindir)
      if l:output =~? 'already up-to-date'
        call add(s:uptodate, fnamemodify(a:plugindir, ':t'))
      elseif l:output =~? 'conflict'
        call add(s:conflict, fnamemodify(a:plugindir, ':t'))
      else
        call add(s:success, fnamemodify(a:plugindir, ':t'))
      endif
    catch
      return 0
    endtry
  elseif !isdirectory(a:plugindir . '/.git')
    call add(s:not_git, fnamemodify(a:plugindir, ':t'))
  endif
  return 1
endfunction

function! s:print_results()
  for [l:msg, l:list] in [
        \                  ['Excluded by User:',   s:excluded],
        \                  ['Updated:',            s:success],
        \                  ['Already Up-to-date:', s:uptodate],
        \                  ['Conflict Issues:',    s:conflict],
        \                  ['Is a Git Repo:',      s:is_git],
        \                  ['Not a Git Repo:',     s:not_git],
        \                ]
    if !empty(l:list)
      echomsg l:msg
      for l:dir in l:list | echomsg ' - ' . l:dir | endfor
    endif
  endfor
endfunction

function! s:pull_from_git(plugindir)
  "return 'conflict'           " uncomment to test the plugin
  "return 'Already up-to-date' " uncomment to test the plugin
  return system('cd ' . a:plugindir . ' && ' . g:update_plugins_git_command)
endfunction

function! s:warn(msg)
  echohl WarningMsg | echomsg 'UpdatePlugins: ' . a:msg | echohl None
endfunction

function! s:create_arrays()
  let s:conflict = []
  let s:success  = []
  let s:not_git  = []
  let s:is_git   = []
  let s:uptodate = []
  let s:excluded = []
endfunction

