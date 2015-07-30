" color scheme
set t_Co=256
colorscheme jellybeans

filetype off

" pathogen
execute pathogen#infect()
execute pathogen#helptags()

" ctrlp
set runtimepath^=~/.vim/bundle/ctrlp.vim

" Automatically format golang files
" filetype plugin indent off
" set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
" autocmd FileType go autocmd BufWritePre <buffer> Fmt

syntax on
set nocompatible
set hls
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set showmatch
set vb t_vb=
set ruler
set incsearch
set expandtab
set shiftround
set undolevels=1000
set pastetoggle=<F2>
set number

let mapleader = ","

" Disable arrow keys
noremap  <Up> ""
noremap! <Up> <Esc>
noremap  <Down> ""
noremap! <Down> <Esc>
noremap  <Left> ""
noremap! <Left> <Esc>
noremap  <Right> ""
noremap! <Right> <Esc>

" Toggle line numbers
nmap <leader>l :set nonumber!<CR>
" Add line above
nmap OO O<ESC>
" Add line below
nmap oo o<ESC>
" Open new tab
nmap tt :tabnew<CR>
" Previous tab
nmap tj :tabp<CR>
" Next tab
nmap tk :tabn<CR>
" Reformat
nmap fff gg=G
" Remove extra whitespace
nmap sss :retab<CR>:%s/\s\+$//c<CR>
" Search for TODOs
nmap td :vimgrep TODO **/*<CR>:cw<CR>
" Grep for the word under the cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Show extra whitespace in red
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

" ag
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor\ --column\ --ignore\ \"public/assets\"
  set grepformat=%f:%l:%c%m

  " Use ag for CtrlP searching
  let g:ctrlp_user_command = 'ag %s -l -i --nogroup --nocolor -g "" --ignore "public/assets"'
endif

" Bind \ to open a quickfix window from a grep search
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag --ignore "public/assets"<SPACE>

" Tabularize comma-separated values
nmap <leader>c :Tabularize /[^,]\+,<CR>

" Toggle Tagbar
nmap tb :TagbarToggle<CR>
" Tagbar jump -- Opens tagbar then closes on tag selection
nmap to :TagbarOpenAutoClose<CR>

" ultisnips
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsEditSplit="vertical"

" vim-airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme           = 'bubblegum'
set noshowmode

" vim-fugitive
nmap gs :Gstatus<CR>

" vim-rspec
map <leader>s :call RunNearestSpec()<CR>
map <Leader>t :call RunCurrentSpecFile()<CR>

:filetype plugin on

runtime macros/matchit.vim

au BufRead,BufNewFile *.rb.sample setfiletype ruby
