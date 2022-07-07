set laststatus=2
set statusline=%1*\ %{GitBranch()}\                    " Git Branch
set statusline+=%2*\ %{@%}%m\                          " File
set statusline+=%=                                     " Right Side
set statusline+=%2*%l/%L\                              " Line Count
set statusline+=%1*\ %{&ft}\                           " File type
set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}\  " Encoding

fun! g:GitBranch()
  let branch = FugitiveStatusline()
  let space = has('nvim') ? " " : ""
  return empty(branch) ? "" : GitSummary(0) . space . branch[5:-3]
endfun

fun! g:GitSummary(int)
  if has('nvim')
    let stats = get(b:, 'gitsigns_status_dict', '')
    return len(stats) == 6 ? '+' . stats['added'] . ' ~' . stats['changed'] . ' −' . stats['removed'] : ''
  endif
  let [a,m,r] = GitGutterGetHunkSummary()
  return a:int ? "" : "+" . a . " ~" . m . " -" . r . " "
endfun

let g:currentmode = {
      \ 'n' : ['Normal', 'NM'],
      \ 'niI' : ['Normal·I', 'NM'],
      \ 'niR' : ['Normal·R', 'NM'],
      \ 'niV' : ['Normal·VR', 'NM'],
      \ 'i' : ['Insert', 'IM'],
      \ 'ix' : ['Completion', 'ICM'],
      \ 'ic' : ['Completion', 'ICM'],
      \ 'v' : ['Visual', 'VM'],
      \ 'V' : ['V·Line', 'VM'],
      \ "\<C-V>" : ['V·Block', 'VM'],
      \ 's' : ['Select', 'SM'],
      \ 'S' : ['S·Line', 'SM'],
      \ "\<C-S>" : ['S·Block', 'SM'],
      \ 'vs' : ['Visual·S', 'VM'],
      \ 'Vs' : ['Visual·SL', 'VM'],
      \ "\<C-V>s" : ['V·Block·SB', 'VM'],
      \ 'R' : ['Replace', 'RM'],
      \ 'Rv' : ['V·Replace', 'VRM'],
      \ 'Rx' : ['Completion·R', 'ICM'],
      \ 'Rc' : ['Completion·R', 'ICM'],
      \ 'Rvc' : ['Completion·VR', 'ICM'],
      \ 'Rvx' : ['Completion·VR', 'ICM'],
      \ 'c' : ['Command', 'CM'],
      \ 'cv' : ['Ex Mode', 'OM'],
      \ 'r' : ['Prompt', 'OM'],
      \ 'rm' : ['More', 'OM'],
      \ 'r?' : ['Confirm', 'OM'],
      \ '!' : ['Shell', 'OM'],
      \ 't' : ['Terminal', 'OM'],
      \ 'no' : ['Operator-pending', 'OM'],
      \ 'nov' : ['Operator-pending', 'OM'],
      \ 'noV' : ['Operator-pending', 'OM']
      \}

fun! g:StatusColor()
  hi NM ctermfg=black ctermbg=34 guifg=#000000 guibg=#00a400
  hi IM ctermfg=black ctermbg=124 guifg=#000000 guibg=#a40000
  hi ICM ctermfg=black ctermbg=33 guifg=#000000 guibg=#007fef
  hi VM ctermfg=black ctermbg=4 guifg=#000000 guibg=#0037da
  hi RM ctermfg=black ctermbg=202 guifg=#000000 guibg=#ca5900
  hi VRM ctermfg=black ctermbg=166 guifg=#000000 guibg=#af5f00
  hi SM ctermfg=black ctermbg=154 guifg=#000000 guibg=#a4f00e
  hi CM ctermfg=black ctermbg=53 guifg=#000000 guibg=#590059
  hi OM ctermfg=black ctermbg=13 guifg=#000000 guibg=#ef3cef
  hi User1 ctermfg=1 ctermbg=0 guifg=#b30000 guibg=#000000
  hi User2 ctermfg=1 ctermbg=234 guifg=#b30000 guibg=#1a1a1a
  hi StatusLine ctermfg=237 ctermbg=196 gui=none guifg=#ef0000 guibg=#363636
  hi StatusLineNC ctermfg=237 ctermbg=196 gui=none guifg=#ef0000 guibg=#363636
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
