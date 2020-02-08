
if !exists('&tagfunc')
    finish
endif

let g:loaded_tagfunc_for_vimscript = 1

function! TagfuncForVimscript(pattern, flags, info) abort
    let name = a:pattern
    if -1 != stridx(name, '#')
        let path = join((['autoload'] + split(name, '#'))[:-2], '/') .. '.vim'
        execute printf('runtime %s', escape(path, ' \'))
    endif
    for cmd in ['function', 'command', 'highlight']
        for line in split(execute(printf('verbose %s %s', cmd, name), 'silent!'), "\n")
            let m = matchlist(line, '^\s*Last set from \(.*\) line \(\d\+\)$')
            if !empty(m)
                let val = #{
                    \   name : name,
                    \   filename : fnamemodify(m[1], ':p'),
                    \   cmd : m[2],
                    \ }
                return [val]
            endif
        endfor
    endfor
    return taglist(a:pattern)
endfunction

augroup tagfunc-for-vimscript
    autocmd!
    autocmd FileType vim :setlocal tagfunc=TagfuncForVimscript
augroup END

