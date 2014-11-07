" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
	finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Set windows runtime path to .vim to make cross OS compatability easier
if has('win32') || has('win64')
	set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

" do not keep a backup file, but use one while writing to disk.
set nobackup
set writebackup	

" put backup and swap files into their own directory
set backupdir=~/.vim/backup
set directory=~/.vim/backup

set history=50		" keep 50 lines of command line history
set ruler			" show the cursor position all the time
set showcmd			" display incomplete commands
set incsearch		" do incremental searching
set smartcase		" ignore case unless you use upper-case characters in search

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2
	syntax on
	set hlsearch
	:nnoremap <space> <Esc>:nohlsearch<Enter>
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72, 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
	" clear the group before adding to it. (prevents problems on loading the .vimrc twice)
	au!

	" For all text files set 'textwidth' to 100 characters.
"	autocmd FileType text setlocal textwidth=100
	autocmd BufNewFile,BufRead *.zsh-theme set filetype=zsh
	autocmd BufNewFile,BufRead prompt_*_setup set filetype=zsh
	autocmd BufNewFile,BufRead *.md set filetype=markdown
	autocmd BufNewFile,BufRead *.make set filetype=make
	autocmd BufNewFile,BufRead *.json,*.pp set foldmethod=marker
	autocmd BufNewFile,BufRead *.json,*.pp set foldmarker={,}
	autocmd BufNewFile,BufRead *.json,*.pp set foldlevel=5

	augroup END
else
	set autoindent		" always set autoindenting on
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif

runtime macros/matchit.vim

" Run pathogen if present
if filereadable(expand("~/.vim/bundle/vim-pathogen/autoload/pathogen.vim"))
	runtime! bundle/vim-pathogen/autoload/pathogen.vim
	if exists("g:loaded_pathogen")
		execute pathogen#infect()
	endif
endif

" Numbers in tabs now in .gvimrc, this is still useful though.
set tabpagemax=1000

if has("multi_byte_encoding") || has("gui_win32")
	set encoding=utf-8
endif

" Tabs and line numbering
set tabstop=4
set shiftwidth=4
set noexpandtab
set number

" Status Line
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

set scrolloff=5			" scroll 5 lines before edge of view.
set cursorline			" highlight current line
set wildmenu			" one of the coolest things.

" Folding
"	zc to fold
"	zo to unfold
if has("folding")
	set foldmethod=syntax	" If present, the best option
	set foldcolumn=1
endif

" Spelling
"	z= to check
"	zg to mark good
if has("spell")
	set spellfile=~/.vim/spell/en.utf-8.add,~/.vim/spell/de.utf-8.add
	set spelllang=en_gb,de,sv
	runtime plugin/spellfile.vim
	"set spell
endif

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" Command *find-manpage*
" TODO: See if there is a tab-friendly version of this.
":runtime! ftplugin/man.vim

" Command :SQLSetType
" TODO: See if there is a way to get this working, it seems to be disabled.
":runtime! ftplugin/sql.vim

" Select :colorscheme based on colours available.
if has("gui_running") || &t_Co >= 256
	colorscheme jellybeans
elseif &t_Co >= 8
	colorscheme default
endif
