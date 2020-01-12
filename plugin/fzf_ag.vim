if exists('g:loaded_fzf_ag')
    finish
endif

let g:loaded_fzf_ag = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=+ -complete=customlist,fzf_ag#complete Ag call fzf#run(fzf_ag#run(<f-args>))

let &cpo = s:save_cpo
unlet s:save_cpo
