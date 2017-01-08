" disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" Map ; to : to avoid mistakes
nnoremap ; :
nmap <silent> ,/ :nohlsearch<CR>

" Map ; to : to avoid mistakes
nnoremap ; :
nmap <silent> ,/ :nohlsearch<CR>

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" Tab navigatin mappings
map to <Esc>:browse tabnew<CR>
map tn <Esc>:tabnew<CR>
map tc <Esc>:tabclose<CR>
map tf <Esc>:tabfirst<CR>
map tp <Esc>:tabp<CR>
map tx <Esc>:tabn<CR>
map tl <Esc>:tablast<CR>

" open a new vertical split
nnoremap <leader>w <C-w>v<C-w>l

" split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Clear search highlights
noremap <silent><leader>/ :nohls<CR>

" fold html tag
nnoremap <leader>ft Vatzf

" open a new vertical split
nnoremap <leader>w <C-w>v<C-w>l

" deopelete kb
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
