"       _
"__   _(_)_ __ ___  _ __ ___
"\ \ / / | '_ ` _ \| '__/ __|
" \ V /| | | | | | | | | (__
"(_)_/ |_|_| |_| |_|_|  \___|
"

" Environment variables:
	set nocompatible
	syntax on
	filetype plugin indent on
	let mapleader=","
	let maplocalleader="-"
	set conceallevel=0
	set encoding=utf-8
	set number
	set relativenumber
	set tabstop=4
	set shiftwidth=4
	set clipboard=unnamedplus				" Allow for use of system-wide copy and paste functions
	set scrolloff=5							" Keep at least 3 lines above/below when scrolling
	set hlsearch							" Highlight search
	set noswapfile							" Don't use swap file
	set incsearch ignorecase				" Increase search
	set smartcase							" Override the 'ignorecase' option if the
											" search pattern contains upper case characters.
	" set foldmethod=expr
	" set foldexpr=nvim_treesitter#foldexpr()
	" set foldtext=substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend))
	" set fillchars=fold:\ 
	" set foldnestmax=3
	" set foldminlines=1
	set foldmethod=manual
	set mouse=a
	set undofile undodir=~/.vim/tmp/undo/	" Set undofiles (undo files even if you exited the file)
	set splitbelow							" Splits open at the bottom and right
	set splitright
	set wildmode=longest,list,full			" Enable autocompletion:
	set wildmenu
	set lazyredraw							" redraw only when we need to.
	set colorcolumn=72						" limit the text input
	set nospell spelllang=en_us,de_de			" spellchecker
	set termguicolors 						" true color support

" Autocommands and keyboard-shortcuts
	autocmd ColorScheme * highlight Conceal ctermfg=red ctermbg=0
	" Automatically deletes all tralling whitespace on save.
		" autocmd BufWritePre * %s/\s\+$//e
	" Disables automatic commenting on newline:
		autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
	" Make 0 go to the first character rather than the beginning
	" " of the line. When we're programming, we're almost always
	" " interested in working with text rather than empty space. If
	" " you want the traditional beginning of line, use ^
		nnoremap 0 ^
		nnoremap ^ 0
	" Fix the go to next line if wrap is enabled
		nnoremap <expr> j v:count ? 'j' : 'gj'
		nnoremap <expr> k v:count ? 'k' : 'gk'
	" Return to last edit position when opening files (You want this!)
		augroup Remember_cursor_position
			autocmd!
			autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
		augroup END
	" Show spaces as red if there's nothing after it (stole Greg Hurrel)
		augroup TrailWhiteSpaces
			highlight ColorColumn ctermbg=1
			autocmd BufWinEnter <buffer> match Error /\s\+$/
			autocmd InsertEnter <buffer> match Error /\s\+\%#\@<!$/
			autocmd InsertLeave <buffer> match Error /\s\+$/
			autocmd BufWinLeave <buffer> call clearmatches()
		augroup END


" ____  _               ____       _   _   _
"|  _ \| |_   _  __ _  / ___|  ___| |_| |_(_)_ __   __ _ ___
"| |_) | | | | |/ _` | \___ \ / _ \ __| __| | '_ \ / _` / __|
"|  __/| | |_| | (_| |  ___) |  __/ |_| |_| | | | | (_| \__ \
"|_|   |_|\__,_|\__, | |____/ \___|\__|\__|_|_| |_|\__, |___/
"               |___/                              |___/

" FZF
fun! s:openFileAtLocation(result)
  if len(a:result) == 0
    return
  endif
  let filePos = split(a:result, ':')
  exec 'edit +' . l:filePos[1] . ' ' . l:filePos[0]
endfun

nnoremap <Leader>f :call fzf#run(fzf#wrap({
  \ 'source': 'rg --line-number ''.*''',
  \ 'options': '--delimiter : --preview "bat --style=plain --color=always {1} -H {2}" --preview-window "+{2}/2"',
  \ 'sink': function('<sid>openFileAtLocation'),
  \ }))<CR><enter>

" WhichKey
lua << EOF
local wk = require("which-key")
wk.setup{}
wk.register({
	c = {
		':exec &conceallevel ? "set conceallevel=0<CR>" : "set conceallevel=1"',
		'toggle conceal'
		},
	i = {
		name = "image",
		i = {":read !echo $(maim -suo | base64)<CR>", "insert image inline (base64)"},
		s = {":!maim -suo screenshot$(($(ls | grep 'screenshot' | wc -l) +1)).png<CR>:read !echo \\[screenshot$(ls | grep 'screenshot' | wc -l).png\\]\\(screenshot$(ls | grep 'screenshot' | wc -l).png\\)", "save image"},
		},
	f = "fuzzy find text",
	l = {
		name = "LSP commands",
 		D = {"<cmd>lua vim.lsp.buf.declaration()<CR>","goto declaration"},
 		d = {"<cmd>lua vim.lsp.buf.definition()<CR>","goto definition"},
 		h = {"<cmd>lua vim.lsp.buf.hover()<CR>","hover"},
 		i = {"<cmd>lua vim.lsp.buf.implementation()<CR>","goto implementation"},
 		s = {"<cmd>lua vim.lsp.buf.signature_help()<CR>","signature help"},
 		w = {
 			name = "Workspace commands",
  			r = {"<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>","remove workspace folder"},
  			a = {"<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>","add workspace folder"},
  			l = {"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>","list workspace folders"},
 			},
 		t = {"<cmd>lua vim.lsp.buf.type_definition()<CR>", "type definition"},
 		r = {"<cmd>lua vim.lsp.buf.rename()<CR>", "rename"},
 		a = {"<cmd>lua vim.lsp.buf.code_action()<CR>", "code action"},
 		R = {"<cmd>lua vim.lsp.buf.references()<CR>", "goto references"},
 		l = {"<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "show line diagnostics"},
 		p = {"<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", "goto previous"},
 		n = {"<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", "goto next"},
 		S = {"<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", "set loclist"},
 		f = {"<cmd>lua vim.lsp.buf.formatting()<CR>", "format"},
		},
}, { prefix = "<leader>" })

if vim.bo.filetype=="clojure" then
	wk.register({
		E = {"evaluate visual selection"},
		e = {
			name = "evaluate",
			b = {"buffer"},
			e = {"inner form"},
			["!"] = {"replace by result"}
			},
		l = {
			name = "log buffer",
			s = {"split horizontally"},
			v = {"split vertically"},
			t = {"new tab"},
			r = {"clear - soft reset"},
			R = {"clear - hard reset"},
			},
	}, { prefix = "<localleader>" })
elseif vim.bo.filetype=="markdown" then
	wk.register({
		c = {
			name = "compile using pandoc",
			p = {":!pandoc<space>%<space>-o<space>%:r.pdf<CR>", "to pdf"},
			h = {":!pandoc<space>%<space>-o<space>%:r.html<CR>", "to html"},
			},
	}, { prefix = "<localleader>" })
end
-- Default localleader settings
wk.register({
	r = {
		name = "REPL (vim-slime)",
		r = {"<Plug>SlimeRegionSend", "send region"},
		p = {"<Plug>SlimeParagraphSend", "send paragraph"},
		c = {"<Plug>SlimeConfig", "edit slime config"},
		}
}, { prefix = "<localleader>" })

-- Default keybingigs in normal mode without any modifiers
wk.register({
	c = {
		s = "change surrounding char arg1 with arg2. cs\"\'"
		}
})
EOF

" Nvim-Cmp
set completeopt=menu,menuone,noselect
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'
  cmp.setup({
    snippet = {
      expand = function(args)
        -- For `vsnip` user.
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'buffer' },
      { name = 'path' },
    }
  })
EOF

" lspconfig
lua << EOF
local nvim_lsp = require('lspconfig')
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings.
  local opts = { noremap=true, silent=true }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'texlab', 'tsserver', 'hls', 'rnix', 'pyright', 'clojure_lsp', 'rls', 'clangd' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

" treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
	},
	rainbow = { -- nvim-ts-rainbow
	  enable = true,
	  extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
	  max_file_lines = nil, -- Do not enable for files with more than n lines, int
	}
}
EOF

" colorscheme
	colorscheme onedark

" markdown
	let g:vim_markdown_folding_disabled = 1

" vim-slime
	let g:slime_target = "neovim"
	let g:slime_no_mappings = 1

" Grammarous settings
	let g:grammarous#languagetool_cmd = 'languagetool'
	let g:grammarous#use_vim_spelllang = 1
	let g:grammarous#default_comments_only_filetypes = {
        \ '*' : 1, 'help' : 0, 'markdown' : 0,
        \ }
	let g:grammarous#hooks = {}
	function! g:grammarous#hooks.on_check(errs) abort
		nmap <buffer><C-n> <Plug>(grammarous-move-to-next-error)
		nmap <buffer><C-p> <Plug>(grammarous-move-to-previous-error)
	endfunction
	function! g:grammarous#hooks.on_reset(errs) abort
		nunmap <buffer><C-n>
		nunmap <buffer><C-p>
	endfunction

" vim2hs
	"let g:haskell_conceal_wide = 1
	let g:haskell_indent_disable=1
	let g:haskell_classic_highlighting=1

" delimitMate
	let delimitMate_expand_space=1
	let delimitMate_expand_cr=1

" vim-skeleton
	" TODO: This should be baked into the nix derivation
	" let g:skeleton_template_dir = "/etc/nixos/nvim/skeleton/"
	let g:skeleton_replacements = {}
	function! g:skeleton_replacements.DATE()
		return strftime("%Y-%m-%d %a %H:%M %S")
	endfunction
	function! g:skeleton_replacements.BASENAMECAPITAL()
		return toupper(expand('%:t:r'))
	endfunction
	function! g:skeleton_replacements.FOLDERNAME()
		return expand('%:p:h:t')
	endfunction
	function! g:skeleton_replacements.AUTHOR()
		return "Luca Leon Happel"
	endfunction

" latex-unicoder.vim
	let g:unicoder_cancel_normal = 1
	let g:unicoder_cancel_insert = 1
	let g:unicoder_cancel_visual = 1
	nnoremap <C-l> :call unicoder#start(0)<CR>
	inoremap <C-l> <Esc>:call unicoder#start(1)<CR>
	vnoremap <C-l> :<C-u>call unicoder#selection()<CR>

" ____       _   _   _
"/ ___|  ___| |_| |_(_)_ __   __ _ ___
"\___ \ / _ \ __| __| | '_ \ / _` / __|
" ___) |  __/ |_| |_| | | | | (_| \__ \
"|____/ \___|\__|\__|_|_| |_|\__, |___/
"                            |___/

" restore folds when reopening files
	" augroup remember_folds
	"   autocmd!
	"   autocmd BufWinLeave * mkview
	"   autocmd BufWinEnter * silent! loadview
	" augroup END

" enable spellchecker with F1
	map <F1> :set spell!<CR>

  " build nix projects with <F9>
    map <F9> :!nix-build<space>--quiet<enter>
    map <S-F9> :!nix-build<enter>

" prettyfy file
	nnoremap <F3> mzgggqG`z

" Sage
	autocmd FileType sage set syntax=python

" GO
	autocmd FileType go noremap <F5> <ESC>:GoRun

" HASKELL
	autocmd FileType haskell setlocal tabstop=2
	autocmd FileType haskell setlocal shiftwidth=2
	autocmd FileType haskell setlocal expandtab
	autocmd FileType cabal setlocal tabstop=2
	autocmd FileType cabal setlocal shiftwidth=2
	autocmd FileType cabal setlocal expandtab

" Nix
	autocmd FileType haskell setlocal tabstop=2
	autocmd FileType haskell setlocal shiftwidth=2
	autocmd FileType haskell setlocal expandtab

" LaTex
	autocmd FileType tex map <F5> :!pdflatex<space>%<enter>

" RMARKDOWN
	" If it is a bookdown book
	if filereadable("_build.sh")
		autocmd FileType rmarkdown map <F5> :!./_build.sh<enter>
	" Otherwise
	else
		autocmd FileType rmarkdown map <F5> :!Rscript<space>-e<space>'library(rmarkdown);render("%")'<enter>
	endif
	autocmd FileType rmadkdown setlocal expandtab
" MARKDOWN
	autocmd FileType markdown setlocal expandtab
	autocmd FileType markdown map <F5> :!pandoc<space>%<space>-o<space>%:r.pdf<enter>