syntax on
set hlsearch
:nnoremap <space> <Esc>:nohlsearch<Enter>

if has("gui_gnome")
	set guifont=DejaVu\ Sans\ Mono\ 11
elseif has("gui_win32")
    set guifont=DejaVu\ Sans\ Mono:h11
	" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
	let &guioptions = substitute(&guioptions, "t", "", "g")
endif

" http://ongardie.net/blog/vim-tabs/
function! GuiTabLabel()
	" buffer_number[+] buffer_name [(number_windows)]

	" Add buffer number
	let label = v:lnum

	" Add '+' if one of the buffers in the tab page is modified
	let bufnrlist = tabpagebuflist(v:lnum)
	for bufnr in bufnrlist
		if getbufvar(bufnr, "&modified")
			let label .= '+'
			break
		endif
	endfor

	" Append the buffer name
	let label .= ' ' . bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])

	" Append the number of windows in the tab page if more than one
	let wincount = tabpagewinnr(v:lnum, '$')
	if wincount > 1
		let label .= ' (' . wincount . ')'
	endif

	return label
endfunction

set guitablabel=%{GuiTabLabel()}
set tabpagemax=1000

cd ~/	" for sanity...
