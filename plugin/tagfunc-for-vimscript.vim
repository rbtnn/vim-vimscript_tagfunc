
scriptencoding utf-8

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
    for cmd in ['function ', printf('function <SNR>%s_', s:get_curr_scriptid()), 'command ', 'highlight ']
        for line in split(execute(printf('verbose %s%s', cmd, name), 'silent!'), "\n")
            let m_en = matchlist(line, '^\s*Last set from \(.*\) line \(\d\+\)$')
            let m_jp = matchlist(line, '^\s*最後にセットしたスクリプト: \(.*\) line \(\d\+\)$')
            for m in [m_en, m_jp]
                if !empty(m)
                    let val = {
                        \   'name' : name,
                        \   'filename' : fnamemodify(m[1], ':p'),
                        \   'cmd' : m[2],
                        \ }
                    return [val]
                endif
            endfor
        endfor
    endfor
    return taglist(a:pattern)
endfunction

function! s:get_curr_scriptid() abort
    let lines = split(execute('scriptnames'), "\n")
    call filter(lines, { _,x -> bufnr(matchstr(x, '^[^:]*:\s*\zs.*$')) == bufnr() })
    return get(map(lines, { _,x -> matchstr(x, '^\s*\zs\d\+\ze:') }), 0, '')
endfunction

augroup tagfunc-for-vimscript
    autocmd!
    autocmd FileType vim :setlocal tagfunc=TagfuncForVimscript
augroup END

