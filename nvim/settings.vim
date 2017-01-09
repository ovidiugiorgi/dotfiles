" Set color scheme
" let g:seoul256_background = 233
" colo seoul256
colorscheme Tomorrow-Night-Eighties
hi Normal ctermbg=none

set relativenumber number " use relative numbers with the current line showing the current line number
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set smartindent

" Custom invisibles
set list
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

" use system clipblard for copy/paste
set clipboard=unnamedplus

" CTRL-P ignore paths
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/](tmp|node_modules|cex_components|bower_components|\.git)'
    \ }

" File tree on F7
map <silent> <F7> :NERDTreeToggle<CR>
let NERDTreeMapActivateNode='<CR>'

" viminfo stores the the state of your previous editing session
set viminfo+=n~/.nvim/viminfo

" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

"airline theme
let g:airline_theme='bubblegum'

" delimitMate settings
let delimitMate_expand_cr=1

" make ultisnips not colide with tab mappings
let g:UltiSnipsExpandTrigger="<S-j>"
let g:UltiSnipsJumpForwardTrigger="<S-j>"
