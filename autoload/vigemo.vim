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
	call s:V.unload()
	return s:V
endfunction


function! vigemo#load()
	call vigemo#vital()
	let s:Commandline = s:V.import("Over.Commandline")
	let s:Migemo      = s:V.import("Migemo.Interactive")
	let s:Highlight   = s:V.import("Coaster.Highlight")
	let s:Modules     = s:V.import("Over.Commandline.Modules")
	let s:Rocker      = s:V.import("Unlocker.Rocker")
	let s:Holder      = s:V.import("Unlocker.Holder")
endfunction
call vigemo#load()


function! vigemo#reload()
	unlet! s:V
	call vigemo#load()
endfunction


function! vigemo#get_migemo()
	return s:Migemo
endfunction


let s:cmdline = s:Commandline.make_standard("/")

call s:cmdline.disconnect("HistAdd")


function! s:cmdline._update(pat)
	call s:Highlight.clear_all()
	let pat = a:pat
	let @/ = pat

	let pat = s:Migemo.generate_regexp(pat)
	if pat == ""
		call self._view.relock()
		call s:Highlight.highlight("cursor", "Cursor", '\%#')
		return
	endif

	let @/ = pat
	set hlsearch
	
	call search(pat, 'c')
	call s:Highlight.highlight("cursor", "Cursor", '\%#')
endfunction


function! s:cmdline.on_char(cmdline)
	if a:cmdline.__is_exit()
		return
	endif
	call self._update(a:cmdline.getline())
endfunction


function! s:cmdline.__execute__(cmd)
	let @/ = s:Migemo.generate_regexp(a:cmd)
	if &hlsearch
		call feedkeys(":set hlsearch\<CR>", "n")
	endif
endfunction


function! s:cmdline.on_enter(...)
	call s:Highlight.clear_all()

	let self._view = s:Rocker.lock(s:Holder.make("Winview"))
	let self._locker = s:Rocker.lock(
\		"&hlsearch"
\	)
	let &hlsearch = 0
endfunction


function! s:cmdline.on_leave(...)
	if self.exit_code() != 0
		call self._view.unlock()
	endif
	call s:Highlight.clear_all()
	call histadd("/", @/)
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
