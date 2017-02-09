"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif


set runtimepath+=/home/ovidiu/.dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('/home/ovidiu/.dein')
" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

" Add or remove your plugins here:
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/deoplete.nvim')
call dein#add('zchee/deoplete-jedi')
call dein#add('scrooloose/nerdtree')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('tpope/vim-commentary')
call dein#add('tpope/vim-surround')
call dein#add('junegunn/seoul256.vim')
call dein#add('vim-airline/vim-airline')
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('carlitux/deoplete-ternjs')
call dein#add('mhartington/deoplete-typescript')
call dein#add('leafgarland/typescript-vim')
call dein#add('flazz/vim-colorschemes')
call dein#add('pangloss/vim-javascript')
call dein#add('airblade/vim-gitgutter')
call dein#add('Raimondi/delimitMate')
call dein#add('SirVer/ultisnips')
call dein#add('honza/vim-snippets')
call dein#add('isRuslan/vim-es6')
call dein#add('tpope/vim-fugitive')
call dein#add('christoomey/vim-tmux-navigator')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('octol/vim-cpp-enhanced-highlight')
call dein#add('edkolev/tmuxline.vim')
call dein#add('altercation/vim-colors-solarized')
call dein#add('jelera/vim-javascript-syntax')

" Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

" Set python paths
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

"End dein Scripts-------------------------
