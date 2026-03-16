" Some time around Zig 0.16.0, the 'zig env' command started writing in Zig
" struct notation instead of JSON.
if !exists('g:zig_std_dir') && executable('zig')
    silent let s:vstr = system('zig version')
    if v:shell_error == 0
        let s:vlist = matchlist(s:vstr, '^\(\d\+\)\.\(\d\+\)\.\(\d\+\)')
        if len(s:vlist) >= 4
            let s:ver = map(s:vlist[1:3], 'str2nr(v:val)')
            if s:ver[0] > 0 || (s:ver[0] == 0 && s:ver[1] >= 16)
                silent let s:env = system('zig env')
                if v:shell_error == 0
                    let g:zig_std_dir = matchstr(s:env, '\.std_dir = "\zs[^"]*\ze"')
                endif
                unlet! s:env
            endif
            unlet! s:ver
        endif
        unlet! s:vlist
    endif
    unlet! s:vstr
endif
