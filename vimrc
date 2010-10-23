source ~/.vim/vimrc

if has("gui_running")
		set lines=45
		set columns=80
		set guifont=Monaco:h14
		colorscheme candycode
else
		set lines=44
		set columns=85
endif

set number

nmap <S-z> :bprevious<CR>
nmap <S-x> :bnext<CR>

"Written by Emerson Vinicius for Convert two Space for Tab
function! ConvertSpaceToTab()
	silent exe ":%s/  /\t/g"
	echo "Save"
endfunction

nmap <leader>t :call ConvertSpaceToTab()<CR>


" Written by steven for quick loadup of Markdown text into HTML
function Mkdp()
  write
  let file   = expand("%")
  let mkd_file = "/tmp/" . file . ".html"
  let result = system("markdown2 " . file . " > " . mkd_file)
  let result = system("open " . mkd_file)
endfunction

:map :mm :call Mkdp()<CR>
