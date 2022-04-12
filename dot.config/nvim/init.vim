set nocompatible

if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
	Plug 'junegunn/vim-plug'

	" Colourschemes
	Plug 'jnurmine/Zenburn'
	Plug 'nanotech/jellybeans.vim'
	Plug 'tomasr/molokai'

	" Utilities
	Plug 'neomake/neomake'             " linters
	Plug 'mhinz/vim-signify'           " git diff
	Plug 'vimwiki/vimwiki'
	Plug 'Yggdroot/indentLine', { 'for': 'python' }  " Messes with concealcursor, breaks vimwiki
	Plug 'norcalli/nvim-colorizer.lua' " colour highlighter
"	Plug 'majutsushi/tagbar'
"	Plug 'junegunn/rainbow_parentheses'
	Plug 'fidian/hexmode'

	" File types
	Plug 'StanAngeloff/php.vim', { 'for': 'php' }
	Plug 'rodjek/vim-puppet',    { 'for': 'puppet' }
	Plug 'tpope/vim-markdown'

call plug#end()

source /home/alex/.config/nvim/plugged/hexmode/plugin/hexmode.vim

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

let g:pyindent_open_paren = '&sw'
let g:pyindent_continue = '&sw'

let g:indentLine_char = '⁞'
"let g:indentLine_char_list = ['|', '┆', '┊']
" tagbar
"	nmap <F8> :TagbarToggle<CR>

colorscheme molokai

call neomake#configure#automake('nrw')
let g:neomake_python_exe = 'python3'
let g:signify_vcs_list = [ 'svn', 'git' ]

" Highlight markdown fenced codeblocks
let g:markdown_fenced_languages = [ 'bash=sh', 'console=sh', 'syslog=messages', 'conf', 'cpp', 'diff', 'groovy', 'html', 'python', 'yaml', 'zsh' ]
let g:markdown_syntax_conceal = 1
let g:markdown_folding = 1
" See also: syn-include syn-region

" UK->US keyboard help for key access
set langmap=£#
" Not setting "@,@" as " is actually more useful

augroup filespecifics
	" PHP
	autocmd BufWritePost *.php silent! !eval '[ -f ~/bin/ctags_php ] && ~/bin/ctags_php' &
	autocmd FileType php setlocal tabstop=4
	autocmd FileType php setlocal shiftwidth=4
	autocmd FileType php setlocal expandtab

	" Ruby
	autocmd FileType ruby setlocal tabstop=2
	autocmd FileType ruby setlocal shiftwidth=2
	autocmd FileType ruby setlocal expandtab

	" Python
	autocmd FileType python setlocal tabstop=4
	autocmd FileType python setlocal shiftwidth=4
	autocmd FileType python setlocal expandtab

	" VimWiki
	autocmd FileType vimwiki setlocal tabstop=2
	autocmd FileType vimwiki setlocal shiftwidth=2
	autocmd FileType vimwiki setlocal noexpandtab
	autocmd FileType vimwiki nmap <C-W><CR> <Plug>VimwikiSplitLink 0 1

augroup END

"let g:vimwiki_listsyms = ' ○◔◑◕●✓'
"let g:vimwiki_listsym_rejected = '✗'
let g:vimwiki_list = [{},{'path': '~/git/personal_wiki/'}]

" whitespace
	" allow backspacing over everything in insert mode
	set backspace=indent,eol,start

	" tabs
	set tabstop=4
	set shiftwidth=4
	set noexpandtab

" line numbering
	set number

" status line
	set laststatus=2
	" file format, encoding, type ([] if empty)
	set statusline =%{&ff},%{strlen(&fenc)?&fenc:'fenc?'}\ [%{&ft}]
	" full path, modified flag, RO, etc
	set statusline+=\ %<%f\ %m%r%q
	" separator
	set statusline+=%=
	" columns: real/virtual, lines: current/total %
	set statusline+=%c%V\ %l/%L\ %4P

	" Correct word wrapping
	set wrap
	set linebreak
	set nolist				" list disables linebreak
	set textwidth=0			" :help fo-table  for other options
	set showbreak=>\ \ 
	set cpoptions+=n		" put the 'showbreak' text in the same column as line numbers
	set cpoptions+=W		" refuse to write to a readonly file

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

	" Better Tag navigation with :tjump
	nnoremap <C-]> g<C-]>
	nnoremap <C-W>] <C-W>g<C-]>

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
	let vimsyn_folding='afP'  " Vim
	let xml_syntax_folding=1  " XML

" spell
	set spellfile=~/.config/nvim/spell/en.utf-8.add
	set spelllang=en_gb
	autocmd FileType gitcommit	setlocal spell
	autocmd FileType svn		setlocal spell
	autocmd FileType asciidoc	setlocal spell
	autocmd FileType vimwiki	setlocal spell

" http://stackoverflow.com/a/15095377
" disable Background Colour Erase for correct rendering in terminal multiplexer
set t_ut=

" gui.txt +408
source $VIMRUNTIME/menu.vim
set wildmenu
set cpo-=<
set wcm=<C-Z>
map <F4> :emenu <C-Z>

" syntax.txt +360
let g:html_dynamic_folds = 1
let g:html_prevent_copy = 'fn'
let g:html_use_encoding = 'UTF-8'

runtime ftplugin/man.vim
let g:ft_man_open_mode = 'tab'
"let g:ft_man_folding_enable = 1
set keywordprg=:Man

let c_space_errors = 1
