
function! update_plugins#set_directory()
  if v:version >= 800 && isdirectory($HOME . "/.vim/pack/")
    return $HOME . '/.vim/pack/*/start/'
  elseif isdirectory($HOME . "/.vim/bundle/")
    return $HOME . '/.vim/bundle/'
  else
    echom "UpdatePlugins: Cound not find a valid plugin directory!"
    finish
  endif
endfunction

function! update_plugins#print_lists(list)
  for [l:msg, l:list] in a:list
    echom l:msg
    if empty(l:list)
      echom ' - None'
    else
      for l:dir in l:list | echom ' - ' . l:dir | endfor
    endif
  endfor
endfunction

function! update_plugins#start()

  let l:plugindirs = split(globpath(g:update_plugins_directory, '*', 0))
  call filter(l:plugindirs, 'isdirectory(v:val)')

  let l:success  = []
  let l:not_git  = []
  let l:uptodate = []

  for l:plugindir in l:plugindirs
    echon "Updating " . l:plugindir . "\r"
    if isdirectory(l:plugindir . '/.git')
      try
        let l:cmd = 'cd ' . l:plugindir . ' && git pull origin master'
        silent! let l:output = system(l:cmd) " Comment out when testing
        "let l:output = 'Already up-to-date' " Un-comment when testing
        if l:output =~? 'Already up-to-date'
          call add(l:uptodate, l:plugindir)
        else
          call add(l:success, l:plugindir)
        endif
      catch
        echom "Caught exception. Stopping update..."
        return
      endtry
    elseif !isdirectory(l:plugindir . '/.git')
      call add(l:not_git, l:plugindir)
    endif
  endfor

  if g:update_plugins_print_results
    call update_plugins#print_lists([['Updated:',            l:success],
          \                          ['Already Up-to-date:', l:uptodate],
          \                          ['Not a Git Repo:',     l:not_git]])
  else
    echo "Done..."
  endif

endfunction

