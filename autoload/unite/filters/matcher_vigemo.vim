scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" Base code
" https://github.com/Shougo/unite.vim/blob/ff2afcbfce1b121251a62258402abe6437e8adb0/autoload/unite/filters/matcher_migemo.vim

let s:Migemo = vigemo#get_migemo()

let s:matcher = {
\	"name" : "matcher_vigemo",
\}

function! s:matcher.filter(candidates, context)
"   let self.migemo_regexp = ""
  let candidates = a:candidates
  for input in a:context.input_list
"     if strlen(input) < 2
"       continue
"     endif
    if input =~ '^!'
      if input == '!'
        continue
      endif
      " Exclusion match.
      let regexp = s:Migemo.generate_regexp(input[1:])
      let expr = 'v:val.word !~ ' .
            \ string(s:Migemo.generate_regexp(input[1:]))
    elseif input =~ '^:'
      " Executes command.
      let a:context.execute_command = input[1:]
      continue
    else
      let self.migemo_regexp = s:Migemo.generate_regexp(input)
      let expr = 'v:val.word =~ ' .
            \ string(self.migemo_regexp)
    endif

    try
      let candidates = unite#filters#filter_matcher(
            \ candidates, expr, a:context)
    catch
      let candidates = []
    endtry
  endfor

  return candidates
endfunction


function! s:matcher.pattern(input)
  if get(self, "migemo_regexp", "") == ""
    return s:Migemo.generate_regexp(a:input)
  else
    return self.migemo_regexp
  endif
endfunction


function! unite#filters#matcher_vigemo#define() "{{{
  return s:matcher
endfunction"}}}


if expand("%:p") == expand("<sfile>:p")
	call unite#define_filter(s:matcher)
endif


let &cpo = s:save_cpo
unlet s:save_cpo
