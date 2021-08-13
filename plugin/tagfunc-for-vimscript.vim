
scriptencoding utf-8

if !exists('&tagfunc')
    finish
endif

let g:loaded_tagfunc_for_vimscript = 1

function! TagfuncForVimscript(pattern, flags, info) abort
	let x = s:check_vim9import()
	if !empty(x)
		return x
	endif
	let name = get(split(a:pattern, ':'), -1, '')
	if -1 != stridx(name, '#')
		let path = join((['autoload'] + split(name, '#'))[:-2], '/') .. '.vim'
		execute printf('runtime %s', escape(path, ' \'))
	endif
	for cmd in ['function ', printf('function <SNR>%s_', s:get_curr_scriptid()), 'command ', 'highlight ']
		for line in split(execute(printf('verbose %s%s', cmd, name), 'silent!'), "\n")
			let m_en = matchlist(line, '^\s*Last set from \(.*\) line \(\d\+\)$')
			let m_jp = matchlist(line, '^\s*最後にセットしたスクリプト: \(.*\) \%(line\|行\) \(\d\+\)$')
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

function! s:check_vim9import() abort
	if !exists(':vim9script')
		return
	endif

	let line = getline('.')
	let st = col('.') - 1

	while line[st] =~# '[a-zA-Z0-9_#.]'
		let st -= 1
	endwhile

	while line[st] !~# '[a-zA-Z0-9_#.]'
		let st += 1
	endwhile

	let ed = st
	while line[ed] =~# '[a-zA-Z0-9_#.]'
		let ed += 1
	endwhile
	let ed -= 1

	let xs = split(line[st : ed], '\.')
	if 2 == len(xs)
		for line in getline(1, line('$'))
			let m = matchlist(line, '^\s*import\s\+\*\s\+as\s\+' .. xs[0] .. '\s\+from\s\+\(.\+\)$')
			if !empty(m)
				return [{
					\   'name' : xs[1],
					\   'filename' : expand('%:h') .. '/' .. eval(m[1]),
					\   'cmd' : '/\<export\>\s\+\<\(def\|const\)\>\s\+' .. xs[1],
					\ }]
			endif
		endfor
	endif

	return []
endfunction

augroup tagfunc-for-vimscript
	autocmd!
	autocmd FileType vim :setlocal tagfunc=TagfuncForVimscript
augroup END

