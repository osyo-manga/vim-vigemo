scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let g:vigemo#debug = get(g:, "vigemo#debug", 0)

function! vigemo#vital()
	if exists("s:V")
		return s:V
	endif
	if g:vigemo#debug
		let s:V = vital#of("vital")
	else
		let s:V = vital#of("vigemo")
	endif
	return s:V
endfunction


function! vigemo#load()
	call vigemo#vital()
	let s:Commandline  = s:V.import("Over.Commandline")
	let s:Migemo = s:V.import("Migemo.Interactive")
	let s:Highlight  = s:V.import("Coaster.Highlight")

	if exists("s:cmigemo")
		call s:cmigemo.kill(1)
	endif

	let s:cmigemo = s:Migemo.make_process()
	call s:cmigemo.wait()

	function! s:cmigemo.then(output, ...)
		let pat = matchstr(a:output, 'PATTERN: \zs.*\ze[\r\n]$')
		if pat == ""
			return
		endif
		let @/ = pat
		call search(@/, "c")
		call s:Highlight.highlight("search", "Search", pat)
		redraw
	endfunction
endfunction
call vigemo#load()


function! vigemo#reload()
	call vital#of("vital").unload()
	call vigemo#load()
endfunction


let s:cmdline = s:Commandline.make_standard("/")

call s:cmdline.connect("AsyncUpdate")


function! s:cmdline.on_update(cmdline)
	call s:cmigemo.update()
endfunction


function! s:cmdline.on_char(cmdline)
	if a:cmdline.__is_exit()
		return
	endif

	let pat = a:cmdline.getline()
	let @/ = pat
	if pat == ""
		call s:Highlight.clear_all()
		return
	endif

	call s:cmigemo.input(pat)
endfunction


function! s:cmdline.__execute__(cmd)
" 	let pat = s:Migemo.generate_regexp(a:cmd)
" 	silent! execute "normal! /" . pat . "\<CR>"
	let @/ = s:Migemo.generate_regexp(a:cmd)
endfunction


function! s:cmdline.on_leave(...)
	call s:Highlight.clear_all()
endfunction


function! s:search(config)
	call s:cmdline.set_prompt(a:config.prompt)
	let exit_code = s:cmdline.start(a:config.input)
	return exit_code
endfunction


let g:vigemo#prompt = get(g:, "vigemo#prompt", "/")
function! vigemo#search(...)
	return s:search({
\		"prompt" : g:vigemo#prompt,
\		"input"  : get(a:, 1, ""),
\	})
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
