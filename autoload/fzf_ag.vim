function! s:error(msg) abort
    throw('fzf-ag.vim: ' . a:msg)
endfunction

function! s:check_dependency() abort
    if !executable('perl')
        call s:error('perl command is not executable')
    endif

    if !executable('ag')
        call s:error('ag command is not executable')
    endif

    if !g:loaded_fzf
        call s:error('not loaded dependent plugin junegunn/fzf.vim')
    endif
endfunction

function! s:open_buffer(lines) abort
    let l:open_mode = get({
                \ 'ctrl-s': 'split',
                \ 'ctrl-v': 'vertical split',
                \ 'ctrl-t': 'tabe'
                \ }, a:lines[0], 'e'
                \ )
    let l:open_files = map(
                \ map(a:lines[1:], { _, v -> split(v, '\s\+') }),
                \ { _, v -> printf('%s | normal %dG', v[0], v[1]) }
                \ )
    call map(l:open_files, { _, v -> execute(join([l:open_mode, v], " ")) })
endfunction

function! fzf_ag#run(...) abort
    if a:0 < 1
        call s:error('no cmd args')
    endif

    call s:check_dependency()

    let l:keyword = a:1
    let l:dirs = a:000[1:]
    if len(dirs) == 0
        let l:dirs = ['']
    endif

    let l:ag_cmd = printf("ag %s %s", l:keyword, join(l:dirs, ' '))
    let l:perl_cmd = "perl -ple 's/^([^:]+):([^:]+):/$1:::$2:::/'"
    let l:fzf_source = join([l:ag_cmd, l:perl_cmd, 'column -t -s ":::"'], ' | ')
    let l:prev_cmd = join([
                \ "perl -e 'print join q/:/, ({2}-10 > 0 ? {2}-10 : 0, {2}+10)'",
                \ "xargs -I {} bat -H {2} --color=always --style=numbers,grid,header --line-range {} {1}"
                \ ], ' | '
                \ )

    if !executable('bat')
        let l:prev_cmd = printf('ag %s {1}', l:keyword)
    endif

    let fzf_dict = {
                \ 'source': l:fzf_source,
                \ 'sink*': function('s:open_buffer'),
                \ 'dir': getcwd(),
                \ 'options': join([
                \   '--expect=ctrl-t,ctrl-v,ctrl-s',
                \   '--multi',
                \   printf('--preview="%s"', l:prev_cmd),
                \   '--preview-window="down"'
                \   ], ' ')
                \ }

    return l:fzf_dict
endfunction

function! fzf_ag#complete(arg_lead, cmd_line, cur_pos) abort
    let l:cmds = split(a:cmd_line, '\s\+')
    let l:len_cmd = len(l:cmds)

    if l:len_cmd <= 1
        return []
    endif

    return split(glob(a:arg_lead . '*'), '\n')
endfunction
