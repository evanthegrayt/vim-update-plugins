" Author: Evan Gray
" Plugin: UpdatePlugins
" Description: Plugin to update git repo plugins
" Date: October 2017

" PUBLIC API

function! update_plugins#UpdateAllPlugins(bang) abort
  call s:CreateArrays()
  let l:plugindirs = s:GetPluginDirs()

  if empty(l:plugindirs)
    call s:Warn('No valid directories found in [' . g:update_plugins_directory . ']')
    return
  endif

  for l:plugindir in l:plugindirs
    if !a:bang && s:IsExcluded(fnamemodify(l:plugindir, ':t'))
      call add(s:excluded, fnamemodify(l:plugindir, ':t'))
    elseif !s:Update(l:plugindir)
      call s:Warn('Script was stopped before it was finished!')
      break
    endif
  endfor

  if g:update_plugins_print_results
    call s:PrintResults()
  else
    echo 'Done...'
  endif
endfunction

function! update_plugins#ListAllPlugins() abort
  call s:CreateArrays()

  let l:plugindirs = s:GetPluginDirs()
  for l:plugindir in l:plugindirs
    if s:IsExcluded(fnamemodify(l:plugindir, ':t'))
      call add(s:excluded, fnamemodify(l:plugindir, ':t'))
    elseif filereadable(l:plugindir . '/.git')
      call add(s:is_git, fnamemodify(l:plugindir, ':t'))
    else
      call add(s:not_git, fnamemodify(l:plugindir, ':t'))
    endif
  endfor

  call s:PrintResults()
endfunction

function! update_plugins#UpdateSinglePlugin(bang, plugindir) abort
  call s:CreateArrays()

  let l:plugindirs = s:GetPluginDirs()
  let l:plugindirsbase = deepcopy(l:plugindirs)
  call map(l:plugindirsbase, 'fnamemodify(v:val, ":t")')
  let l:idx = match(l:plugindirsbase, a:plugindir)
  if l:idx == -1
    call s:Warn(a:plugindir . ' is not a plugin!')
    return
  endif

  let l:plugindir = l:plugindirs[l:idx]

  if !a:bang && s:IsExcluded(a:plugindir)
    call s:Warn('Directory ' . a:plugindir . ' excluded by user!')
    return
  else
    call s:Update(l:plugindir)
  endif

  call s:PrintResults()
endfunction

function! update_plugins#Completion(...) abort
  call s:CreateArrays()

  let l:plugindirs = s:GetPluginDirs()
  for l:plugindir in l:plugindirs
    if filereadable(l:plugindir . '/.git')
      call add(s:is_git, fnamemodify(l:plugindir, ':t'))
    endif
  endfor

  return s:is_git
endfunction

" PRIVATE API

function s:IsExcluded(plugin) abort
  if !empty(g:update_plugins_exclude)
    for l:item in g:update_plugins_exclude
      if l:item ==? a:plugin | return 1 | endif
    endfor
  endif
  return 0
endfunction

function! s:Update(plugindir) abort
  if s:IsGit(a:plugindir)
    echon 'Updating ' . a:plugindir . "\r"
    try
      let l:output = s:PullFromGit(a:plugindir)
      if match(l:output, "already\.up\.to\.date") >= 0
        call add(s:uptodate, fnamemodify(a:plugindir, ':t'))
      elseif l:output =~? 'conflict'
        call add(s:conflict, fnamemodify(a:plugindir, ':t'))
      elseif l:output =~? "fast\.forward"
        call add(s:success, fnamemodify(a:plugindir, ':t'))
      else
        call add(s:unknown, fnamemodify(a:plugindir, ':t'))
      endif
    catch
      return 0
    endtry
  elseif !isdirectory(a:plugindir . '/.git')
    call add(s:not_git, fnamemodify(a:plugindir, ':t'))
  endif
  return 1
endfunction

function! s:PrintResults() abort
  for [l:msg, l:list] in [
        \   ['Excluded by User:',   s:excluded],
        \   ['Updated:',            s:success],
        \   ['Already Up-to-date:', s:uptodate],
        \   ['Conflict Issues:',    s:conflict],
        \   ['Is a Git Repo:',      s:is_git],
        \   ['Not a Git Repo:',     s:not_git],
        \   ['Unknown Status:',     s:unknown],
        \ ]
    if !empty(l:list)
      echomsg l:msg
      for l:dir in l:list | echomsg ' - ' . l:dir | endfor
    endif
  endfor
endfunction

function! s:PullFromGit(plugindir) abort
  "return 'conflict'           " uncomment to test the plugin
  "return 'Already up-to-date' " uncomment to test the plugin
  return system('cd ' . a:plugindir . ' && ' . g:update_plugins_git_command)
endfunction

function! s:Warn(msg) abort
  echohl WarningMsg | echomsg 'UpdatePlugins: ' . a:msg | echohl None
endfunction

function! s:CreateArrays() abort
  let s:conflict = []
  let s:success  = []
  let s:not_git  = []
  let s:is_git   = []
  let s:uptodate = []
  let s:excluded = []
  let s:unknown  = []
endfunction

function! s:GetPluginDirs() abort
  let l:plugindirs = []
  let l:plugindirlocations = expand(g:update_plugins_directory, 0, 1)
  for l:plugindirlocation in l:plugindirlocations
    call extend(l:plugindirs, filter(globpath(l:plugindirlocation, '*', 0, 1),
          \'isdirectory(v:val)'))
  endfor
  return l:plugindirs
endfunction

function! s:IsGit(plugindir) abort
  return filereadable(a:plugindir . '/.git')
endfunction
