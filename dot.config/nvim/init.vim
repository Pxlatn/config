set nocompatible

""	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin()

" utilities
"	Plug 'scrooloose/nerdtree'
	Plug 'msanders/snipmate.vim'
	Plug 'scrooloose/syntastic'

" filetypes
	Plug 'rodjek/vim-puppet', { 'for': 'puppet' }
	Plug 'elzr/vim-json', { 'for': 'json' }
	Plug 'othree/xml.vim', { 'for': 'xml' }
	" https://github.com/LeonB/vim-nginx
	Plug '~/.config/nvim/vim-nginx', { 'for': 'nginx' }

" themes
	Plug 'jnurmine/Zenburn'
	Plug 'nanotech/jellybeans.vim'
	Plug 'whatyouhide/vim-gotham'
	Plug 'tomasr/molokai'
	Plug 'cschlueter/vim-wombat'
"	Plug 'chriskempson/base16-vim'

call plug#end()

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

" syntax and colours
"let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" https://gist.github.com/XVilka/8346728
"set termguicolors
"colorscheme jellybeans
colorscheme molokai

" whitespace
	" allow backspacing over everything in insert mode
	set backspace=indent,eol,start

	" tabs
	set tabstop=4
	set shiftwidth=4
	set noexpandtab

" line numbering
	set number
	set relativenumber

" status line
	set laststatus=2
	set highlight+=sb,Sr
	""""""""""""""==									"
	set statusline =\ \ %{&ff},							"file format
	set statusline+=%{strlen(&fenc)?&fenc:'fenc?'}		"file encoding
	set statusline+=\ [%{strlen(&ft)?&ft:'ft?'}]		"file type
	set statusline+=\ %<%f								"full path
	set statusline+=\ %m								"modified flag
	set statusline+=%=
	set statusline+=%{v:register}						"current buffer
	set statusline+=\ \ %c%V							"line/virtual column number
	set statusline+=\ %l								"current line
	set statusline+=/%L									"total lines
	set statusline+=\ %4P\ 								"percentage

" Correct word wrapping
	set wrap
	set linebreak
	set nolist				" list disables linebreak
	set textwidth=0			" :help fo-table  for other options
	set showbreak=>\ \ 
	set cpoptions+=n		" put the 'showbreak' text in the same column as line numbers

	" Make j/k move through wrapped lines intuitively
	nnoremap j gj
	nnoremap k gk
	nnoremap gj j
	nnoremap gk k

" commands and behaviour
	"set hlsearch
	:nnoremap <space> <Esc>:nohlsearch<Enter>

	set scrolloff=5			" scroll 5 lines before edge of view.
	set cursorline			" highlight current line
	set wildmenu			" command line autocompletion with menu
	set splitbelow			" Split in a way more intuitive
	set splitright			" ^^^^^
	set modeline

	" Don't use Ex mode, use Q for formatting
	map Q gq

	" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
	" so that you can undo CTRL-U after inserting a line break.
	inoremap <C-U> <C-G>u<C-U>

	" DiffOrig - compare to original
	if !exists(":DiffOrig")
		command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
	endif

" folding
	set foldmethod=syntax	" If present, the best option
	set foldcolumn=1
	set foldlevelstart=1
	let javaScript_fold=1     " JavaScript
	let perl_fold=1           " Perl
	let php_folding=1         " PHP
	let r_syntax_folding=1    " R
	let ruby_fold=1           " Ruby
	let sh_fold_enabled=1     " sh
	let vimsyn_folding='af'   " Vim
	let xml_syntax_folding=1  " XML

" spell
"	set spellfile=~/.config/nvim/spell/en.utf-8.add,~/.config/nvim/spell/de.utf-8.add
	set spelllang=en_gb,de
	autocmd FileType gitcommit	setlocal spell
	autocmd FileType svn		setlocal spell
	autocmd FileType asciidoc	setlocal spell
