set nocompatible

"" vim-plug
"""""""""""""

let g:data_dir = glob(has('nvim') ? stdpath('config') : '~/.vim')
let plug_data_dir = g:data_dir . '/plugged'
let g:plug_shallow = 1

if !exists('g:enable_linting')
	let g:enable_linting = empty($SSH_CLIENT)
endif

if !exists('g:load_plugins') || g:load_plugins
	if empty(glob(g:data_dir . '/autoload/plug.vim'))
		if exepath('curl') != '' && exepath('git') != ''
			silent execute '!curl -fLo '.g:data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
			"autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
		else
			echo 'curl/git not available, not loading plugins'
			echo 'curl: ' exepath('curl')
			echo 'git:  ' exepath('git')
			let g:load_plugins = 0
		endif
	endif
endif

" Re-open conditional, to allow above to set g:load_plugins to 0
if !exists('g:load_plugins') || g:load_plugins
	silent! call plug#begin(plug_data_dir)
		Plug 'junegunn/vim-plug'

		" Filetypes to conditionally include
		let incl_filetypes = {
		\	'cfengine': 'neilhwatson/vim_cf3',
		\	'epics':    'nickez/epics.vim',
		\	'logstash': 'robbles/logstash.vim',
		\	'mustache': 'mustache/vim-mustache-handlebars',
		\	'nginx':    'chr4/nginx.vim',
		\	'php':      'StanAngeloff/php.vim',
		\	'puppet':   'rodjek/vim-puppet',
		\}
		if !exists('g:include_filetypes')
			let g:include_filetypes = keys(incl_filetypes)
		endif
		for type in g:include_filetypes
			Plug incl_filetypes[type]
		endfor

		" Filetypes to always include
		Plug 'pedrohdz/vim-yaml-folds' " yaml

		" Utilities
		Plug 'vimwiki/vimwiki'      " vimwiki
		Plug 'vimwiki/utils', { 'dir': plug_data_dir . '/vimwiki-utils' }
		Plug 'junegunn/fzf', { 'do': ':call fzf#install()' }
		Plug 'preservim/tagbar'     " ctags sidebar
		Plug 'neomake/neomake'      " linters
		Plug 'fidian/hexmode'       " hexedit functionality using xxd
		Plug 'tpope/vim-fugitive'   " git
		Plug 'tpope/vim-unimpaired' " vim list navigation
		Plug 'Konfekt/FastFold'     " Faster folding
		Plug 'tmhedberg/SimpylFold' " Python folding

	"	https://github.com/Shougo/ddc.vim

		if has('nvim') || has('patch-8.0.902')
			Plug 'mhinz/vim-signify'   " GIT flagging
		else
			Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
		endif

		if has('nvim')
			Plug 'norcalli/nvim-colorizer.lua' " colour highlighter
		endif

		" Colourschemes
		Plug 'nanotech/jellybeans.vim'
		Plug 'tomasr/molokai'
		Plug 'NLKNguyen/papercolor-theme'

	call plug#end()
endif

"" Plugin configuration
"""""""""""""""""""""""""

" Plug: vimwiki
let wiki = {}
let wiki.nested_syntaxes = {'bash': 'sh'}
let wiki.auto_diary_index = 1
let wiki.auto_tags = 1
let g:vimwiki_list = [wiki]
let g:vimwiki_folding = 'expr'
let g:vimwiki_global_ext = 1
let g:vimwiki_hl_headers = 1
let g:vimwiki_auto_header = 1
autocmd FileType vimwiki setlocal tabstop=2
autocmd FileType vimwiki setlocal shiftwidth=2
autocmd FileType vimwiki setlocal noexpandtab
" Add <C-W><CR> to open links in a split
autocmd FileType vimwiki nmap <C-W><CR> <Plug>VimwikiSplitLink 0 1
" C-S-CR doesn't seem to work, so add <Leader><CR> to open links in tab
autocmd FileType vimwiki nmap <Leader><CR> <Plug>VimwikiTabnewLink
" Add vim-unimpaired style diary navigation
autocmd FileType vimwiki nmap [d <Plug>VimwikiDiaryPrevDay
autocmd FileType vimwiki nmap ]d <Plug>VimwikiDiaryNextDay

" Error detected while processing ~/.vim/plugged/vimwiki/syntax/vimwiki.vim:
" E410: Invalid :syntax subcommand: iskeyword
" https://github.com/vim/vim/releases/tag/v7.4.1142
if !has('patch-7.4.1142')
	let g:vimwiki_emoji_enable = 0
endif

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
if has_key(plugs, 'neomake')
	if g:enable_linting
		call neomake#configure#automake('nrw')
	else
		call neomake#configure#automake('')
	endif
	nmap <F8> :Neomake<CR>
else
   echo 'neomake not loaded'
endif

" Plug: vim-signify
let g:signify_skip = { 'vcs': { 'allow': ['git', 'svn'] } }
if has('nvim') || has('patch-8.2.3874')
	let g:signify_number_highlight = 1
endif

" Plug: hexmode
nmap <F10> :Hexmode<CR>

" Plug: SimpylFold
let g:SimpylFold_docstring_preview = 1

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
	set foldcolumn=1
	set foldlevelstart=10
	" :help syntax.txt
	let g:javaScript_fold=1     " JavaScript
	let g:perl_fold=1           " Perl
	let g:perl_fold_blocks=1
	let g:php_folding=1         " PHP
	let g:r_syntax_folding=1    " R
	let g:ruby_fold=1           " Ruby
	let g:sh_fold_enabled=7     " sh
	let g:zsh_fold_enable=1
	let g:vimsyn_folding='af'   " Vim
	let g:xml_syntax_folding=1  " XML
	let g:markdown_folding=1    " MarkDown
	let g:tex_fold_enabled=1
	let g:rust_fold=1           " Rust
	let g:rst_fold_enabled=1
	let g:fortran_fold=1
	let g:clojure_fold=1
	let g:baan_fold=1
endif

filetype plugin indent on
augroup vimrcEx
au!
	autocmd BufNewFile,BufRead *.md      set filetype=markdown
	autocmd BufNewFile,BufRead *.make    set filetype=make
	autocmd BufNewFile,BufRead *.service set filetype=systemd
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
"highlight ExtraWhitespace ctermbg=darkgrey guibg=black
highlight link ExtraWhitespace Error
" CursorLine
"autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgrey guibg=black
" trailing ws | space before tab | non-indenting tab
let g:whitespace_matcher = matchadd('ExtraWhitespace', '\v\s+$| +\ze\t|[^\t]\zs\t+', -1)

" Colourscheme configuration
if &t_Co > 2 " if colours
	syntax on
	set hlsearch
	if &t_Co > 64
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
	else
		if exists("*ToggleBackground") == 0
			try
				silent colorscheme default
				" Hack a similar functionality for low colours
				function ToggleBackground()
					if !exists('g:background')
						let g:background = &background
					endif
					if g:background == "dark"
						let g:background = 'light'
						colorscheme morning
					else
						let g:background = 'dark'
						colorscheme default
					endif
				endfunction
			catch
				" no default colorscheme, giving up
			endtry
		endif
	endif
	if exists("*ToggleBackground")
		command! ToggleBackground call ToggleBackground()
		nmap <F3> :ToggleBackground<CR>
	endif
endif

"" Bracketed Paste
""""""""""""""""""""

" bracketed paste -> automated paste mode
" https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

"" Keyboard mappings
""""""""""""""""""""""

set pastetoggle=<F2>
nnoremap <Space> <Esc>:nohlsearch<Enter>
nmap <F9> :setlocal wrap!<CR>
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

dig ?! 8253 " ‽
dig !? 8253 " ‽

"" General Settings
"""""""""""""""""""""

" Backups:
set nobackup
set writebackup
let &backupdir = g:data_dir . '/backup'
let &directory = g:data_dir . '/backup'
if !isdirectory(&backupdir)
	call mkdir(&backupdir, 'p')
endif

" map UK>US for normal mode (helps with searching)
try
	let s:oldlangmap = &langmap
	set langmap+=£;#
catch /E357/
	" That didn't work, likely because the multicharacter "£"
	let &langmap = s:oldlangmap
finally
	unlet s:oldlangmap
endtry

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

