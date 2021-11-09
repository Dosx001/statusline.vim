set laststatus=2
set statusline=%1*\ %{GitBranch()}\                    " Git Branch
set statusline+=%2*\ %{@%}%m\                          " File
set statusline+=%=                                     " Right Side
set statusline+=%2*%l/%L\                              " Line Count
set statusline+=%1*\ %{&ft}\                           " File type
set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}\  " Encoding

fun! g:GitBranch()
    let branch = FugitiveStatusline()
    return empty(branch) ? "" : GitSummary(0) . branch[5:-3]
endfun

fun! g:GitSummary(int)
    let [a,m,r] = GitGutterGetHunkSummary()
    return a:int ? "" : "+" . a . " ~" . m . " -" . r . " "
endfun

let g:currentmode = {
            \ 'n' : ['Normal', 'NM'],
          \ 'niI' : ['Normal', 'NM'],
          \ 'niR' : ['Normal', 'NM'],
          \ 'niV' : ['Normal', 'NM'],
            \ 'i' : ['Insert', 'IM'],
           \ 'ix' : ['Completion', 'ICM'],
           \ 'ic' : ['Completion', 'ICM'],
            \ 'v' : ['Visual', 'VM'],
            \ 'V' : ['V·Line', 'VM'],
       \ "\<C-V>" : ['V·Block', 'VM'],
            \ 's' : ['Select', 'SM'],
            \ 'S' : ['S·Line', 'SM'],
       \ "\<C-S>" : ['S·Block', 'SM'],
            \ 'R' : ['Replace', 'RM'],
           \ 'Rv' : ['V·Replace', 'RM'],
           \ 'Rx' : ['C·Replace', 'RM'],
           \ 'Rc' : ['C·Replace', 'RM'],
            \ 'c' : ['Command', 'CM'],
           \ 'ce' : ['Ex', 'OM'],
            \ 'r' : ['Prompt', 'OM'],
           \ 'rm' : ['More', 'OM'],
           \ 'r?' : ['Confirm', 'OM'],
            \ '!' : ['Shell', 'OM'],
            \ 't' : ['Terminal', 'OM']
            \}

hi NM ctermfg=black ctermbg=34
hi IM ctermfg=black ctermbg=124
hi ICM ctermfg=black ctermbg=33
hi VM ctermfg=black ctermbg=4
hi RM ctermfg=black ctermbg=166
hi SM ctermfg=black ctermbg=154
hi CM ctermfg=black ctermbg=53
hi OM ctermfg=black ctermbg=13
hi User1 ctermfg=1 ctermbg=0
hi User2 ctermfg=1 ctermbg=234
hi StatusLine ctermfg=237 ctermbg=196
hi StatusLineNC ctermfg=237 ctermbg=196

fun! StatueLine(statusline)
    let [mode, color] = g:currentmode[mode(1)]
    return '%#' . color . '# ' . mode . ' ' . a:statusline
endfun

augroup StatusLine
    autocmd!
    au WinEnter,TabEnter,BufWinEnter,SourcePost *
        \ setlocal statusline& |
        \ let statusline=&statusline |
        \ setlocal statusline=%!StatueLine(statusline)
    au WinLeave,TabLeave * setlocal statusline=%2*\ %{@%}%m\ %{GitSummary(empty(FugitiveStatusline())?1:0)}
augroup END
