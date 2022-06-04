set nocompatible

"" vim-plug
"""""""""""""

let data_dir = glob(has('nvim') ? stdpath('config') : '~/.vim')

if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:plug_shallow = 1

let plug_data_dir = data_dir . '/plugged'
call plug#begin(plug_data_dir)
	Plug 'junegunn/vim-plug'

	" Filetypes to conditionally include
	let incl_filetypes = {
	\	'cfengine': 'neilhwatson/vim_cf3',
	\	'epics':    'nickez/epics.vim',
	\	'puppet':   'rodjek/vim-puppet',
	\	'php':      'StanAngeloff/php.vim',
	\}
	if exists('g:include_filetypes')
		for type in g:include_filetypes
			Plug incl_filetypes[type]
		endfor
	endif

	" Filetypes to always include
	Plug 'pedrohdz/vim-yaml-folds' " yaml

	" Utilities
	Plug 'vimwiki/vimwiki'     " vimwiki
	Plug 'vimwiki/utils', { 'dir': plug_data_dir . '/vimwiki-utils' }
	Plug 'junegunn/fzf', { 'do': ':call fzf#install()' }
	Plug 'preservim/tagbar'    " ctags sidebar
	Plug 'neomake/neomake'     " linters
	Plug 'fidian/hexmode'      " hexedit functionality using xxd

"	https://github.com/Shougo/ddc.vim

	if has('nvim') || has('patch-8.0.902')
		Plug 'mhinz/vim-signify'   " GIT flagging
	else
		Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
	endif

	if has('nvim')
		Plug 'norcalli/nvim-colorizer.lua' " colour highlighter
	endif

	" Colourschemes
	Plug 'nanotech/jellybeans.vim'
	Plug 'tomasr/molokai'
	Plug 'NLKNguyen/papercolor-theme'

call plug#end()

"" Plugin configuration
"""""""""""""""""""""""""

" Plug: vimwiki
let wiki = {}
let wiki.nested_syntaxes = {'bash': 'sh'}
let g:vimwiki_list = [wiki]
let g:vimwiki_folding = 'expr'
let g:vimwiki_global_ext = 0
let g:vimwiki_hl_headers = 1
autocmd FileType vimwiki setlocal tabstop=2
autocmd FileType vimwiki setlocal shiftwidth=2
autocmd FileType vimwiki setlocal noexpandtab
" Add <C-W><CR> to open links in a split
autocmd FileType vimwiki nmap <C-W><CR> <Plug>VimwikiSplitLink 0 1
" C-S-CR doesn't seem to work, so add <Leader><CR> to open links in tab
autocmd FileType vimwiki nmap <Leader><CR> <Plug>VimwikiTabnewLink

" Plug: vimwiki + tagbar
" extend tagbar to handle vimwiki
let g:tagbar_type_vimwiki = {
\	'ctagstype': 'vimwiki',
\	'kinds': ['h:header'],
\	'sro': '&&&',
\	'kind2scope': {'h':'header'},
\	'sort': 0,
\	'ctagsbin': plug_data_dir . '/vimwiki-utils/vwtags.py',
\	'ctagsargs': 'default'
\}
nmap <F4> :TagbarToggle<CR>

" Plug: FZF
if exists('$TMUX')
	let g:fzf_layout = { 'tmux': '-p90%,60%' }
endif
" Colour FZF with colourscheme classes
let g:fzf_colors = {
\	'fg':      ['fg', 'Normal'],
\	'bg':      ['bg', 'Normal'],
\	'hl':      ['fg', 'Comment'],
\	'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
\	'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
\	'hl+':     ['fg', 'Statement'],
\	'info':    ['fg', 'PreProc'],
\	'border':  ['fg', 'Ignore'],
\	'prompt':  ['fg', 'Conditional'],
\	'pointer': ['fg', 'Exception'],
\	'marker':  ['fg', 'Keyword'],
\	'spinner': ['fg', 'Label'],
\	'header':  ['fg', 'Comment']
\}

" Add a new command :FGF to FZF in the git repo containing the current file (pinned to the repo root)
if !exists(":FGF")
	command FGF :call fzf#run(fzf#wrap({ 'source': 'git ls-files :/', 'dir': expand('%:h') }))
endif

" Plug: PaperColor
" Configure PaperColor colorscheme to highlight stdlibs
let g:PaperColor_Theme_Options = {
\	'language': {
\		'python': {
\			'highlight_builtins' : 1
\		},
\		'cpp': {
\			'highlight_standard_library': 1
\		},
\		'c': {
\			'highlight_builtins' : 1
\		}
\	}
\}

" Plug: neomake
call neomake#configure#automake('nrw')

" Plug: vim-signify
let g:signify_vcs_list = [ 'svn', 'git' ]


"" Builtin configuration
""""""""""""""""""""""""""

" Add :Man command to open man pages in a new tab
runtime ftplugin/man.vim
let g:ft_man_open_mode = 'tab'
let g:ft_man_folding_enable = 1
set keywordprg=:Man

" python.vim
let g:pyindent_open_paren = '&sw'
let g:pyindent_continue = '&sw'
let python_space_error_highlight = 1

" markdown
let g:markdown_fenced_languages = [ 'bash=sh', 'console=sh', 'syslog=messages' ]
let g:markdown_syntax_conceal = 1
let g:markdown_folding = 1
" See also: syn-include syn-region

" syntax.txt +360
:let g:html_dynamic_folds = 1
:let g:html_prevent_copy = 'fn'
:let g:html_use_encoding = 'UTF-8'

" Mouse
if has('mouse')
	set mouse=a " all
endif

if has("folding")
	set foldmethod=syntax     " If present, the best option
	set foldcolumn=2
	set foldlevelstart=10
	" :help syntax.txt
	let javaScript_fold=1     " JavaScript
	let perl_fold=1           " Perl
	let php_folding=1         " PHP
	let r_syntax_folding=1    " R
	let ruby_fold=1           " Ruby
	let sh_fold_enabled=1     " sh
	let vimsyn_folding='af'   " Vim
	let xml_syntax_folding=1  " XML
endif

filetype plugin indent on
augroup vimrcEx
au!
	autocmd BufNewFile,BufRead *.md   set filetype=markdown
	autocmd BufNewFile,BufRead *.make set filetype=make
	autocmd BufNewFile,BufRead *.css,*.scss,*.less setlocal foldmethod=marker foldmarker={,}
	autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
	autocmd FileType cf3,yaml setlocal tabstop=2 shiftwidth=2 expandtab
augroup END

if has("spell")
	set spellfile=~/.vim/spell/en.utf-8.add
	set spelllang=en_gb
	runtime plugin/spellfile.vim

	augroup vimrcSpell
	au!
	autocmd FileType gitcommit setlocal spell
	autocmd FileType svn       setlocal spell
	autocmd FileType asciidoc  setlocal spell
	autocmd FileType vimwiki   setlocal spell
	augroup END
	" toggle spell on <F7>
	nmap <F7> :setlocal spell!<CR>
	" prev/next error on <F5>/<F6>
	map <F5> [s
	map <F6> ]s
endif

" Open the version of the file on disk with a diff
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif

" https://vim.fandom.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=darkgrey guibg=black
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgrey guibg=black
" trailing ws | space before tab | non-indenting tab
let w:wsm = matchadd('ExtraWhitespace', '\v\s+$| +\ze\t|[^\t]\zs\t+', -1)

" Colourscheme configuration
if &t_Co > 2 " if colours
	syntax on
	set hlsearch
	set background=dark
	colorscheme PaperColor
	if exists("*ToggleBackground") == 0
		function ToggleBackground()
			if &background == "dark"
				set background=light
			else
				set background=dark
			endif
		endfunction
	endif
	command! ToggleBackground call ToggleBackground()
	nmap <F3> :ToggleBackground<CR>
endif

"" Keyboard mappings
""""""""""""""""""""""

set pastetoggle=<F2>
nnoremap <Space> <Esc>:nohlsearch<Enter>
" make some keys more intuitive
map Q gq
inoremap <C-U> <C-G>u<C-U>
set backspace=indent,eol,start
" Make j/k move through wrapped lines intuitively
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
" Better Tag navigation with :tjump
nnoremap <C-]> g<C-]>
nnoremap <C-W>] <C-W>g<C-]>

"" General Settings
"""""""""""""""""""""

" Backups:
set nobackup
set writebackup
let &backupdir = data_dir . '/backup'
let &directory = data_dir . '/backup'

" map UK>US for normal mode (helps with searching)
set langmap=£#

set number
set ruler
set showcmd
set incsearch
set smartcase

set modeline
set tabstop=4
set shiftwidth=4
set noexpandtab

set wrap
set linebreak
set nolist           " list disables linebreak
set textwidth=0      " :help fo-table  for other options
set showbreak=>\ \ 
set cpoptions+=n     " put the 'showbreak' text in the same column as line numbers

set scrolloff=5
set cursorline
set wildmenu
set splitbelow
set splitright

" Status Line
set laststatus=2

set statusline =\ \ %{&ff},                     "file format
set statusline+=%{strlen(&fenc)?&fenc:'fenc?'}  "file encoding
set statusline+=\ [%{strlen(&ft)?&ft:'ft?'}]    "file type
set statusline+=\ %<%f                          "full path
set statusline+=\ %m                            "modified flag
set statusline+=%=                              " ----------
set statusline+=%{v:register}                   "current buffer
set statusline+=\ \ %c%V                        "line/virtual column number
set statusline+=\ %l                            "current line
set statusline+=/%L                             "total lines
set statusline+=\ %4P\                          "percentage

