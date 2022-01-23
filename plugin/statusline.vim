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

fun! g:StatusColor()
  hi NM ctermfg=black ctermbg=34 guifg=#000000 guibg=#00a400
  hi IM ctermfg=black ctermbg=124 guifg=#000000 guibg=#a40000
  hi ICM ctermfg=black ctermbg=33 guifg=#000000 guibg=#007fef
  hi VM ctermfg=black ctermbg=4 guifg=#000000 guibg=#0037da
  hi RM ctermfg=black ctermbg=166 guifg=#000000 guibg=#ca5900
  hi SM ctermfg=black ctermbg=154 guifg=#000000 guibg=#a4f00e
  hi CM ctermfg=black ctermbg=53 guifg=#000000 guibg=#590059
  hi OM ctermfg=black ctermbg=13 guifg=#000000 guibg=#ef3cef
  hi User1 ctermfg=1 ctermbg=0 guifg=#b30000 guibg=#000000
  hi User2 ctermfg=1 ctermbg=234 guifg=#b30000 guibg=#1a1a1a
  hi StatusLine ctermfg=237 ctermbg=196 guifg=#363636 guibg=#ef0000
  hi StatusLineNC ctermfg=237 ctermbg=196 guifg=#363636 guibg=#ef0000
endfun

fun! StatueLine(statusline)
  let [mode, color] = g:currentmode[mode(1)]
  return '%#' . color . '# ' . mode . ' ' . a:statusline
endfun

augroup StatusLine
  au!
  au ColorScheme,SourcePost * call g:StatusColor()
  au WinEnter,TabEnter,BufWinEnter,SourcePost *
        \ setlocal statusline& |
        \ let statusline=&statusline |
        \ setlocal statusline=%!StatueLine(statusline)
  au WinLeave,TabLeave * setlocal statusline=%2*\ %{@%}%m\ %{GitSummary(empty(FugitiveStatusline())?1:0)}
augroup END
