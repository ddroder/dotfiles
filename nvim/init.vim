set termguicolors
set number
syntax on
set clipboard=unnamedplus
set expandtab
set wildmode=longest,list
set showmatch
set ignorecase
set hlsearch
set incsearch
set tabstop=4
set softtabstop=4
set autoindent
filetype plugin indent on
set noswapfile
set relativenumber


let g:mkdp_browser='firefox'
let g:python3_host_prog="/Library/Frameworks/Python.framework/Versions/3.12/bin/python3"
let g:coc_global_extensions = ['coc-pyright', 'coc-json', 'coc-yaml']
let g:coc_semantic_highlight_method = 'highlight'  " or disable entirely
let g:coc_disable_semantic_tokens = 1
let b:coc_diagnositc_disable=1
let g:coc_diagnostic_virtual_text = 0
let g:tmux_navigator_no_maappings=1


call plug#begin()
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'RyanMillerC/better-vim-tmux-resizer'
Plug 'nvim-lua/plenary.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'Vigemus/iron.nvim'
Plug 'goolord/alpha-nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'GCBallesteros/NotebookNavigator.nvim'
Plug 'nosduco/remote-sshfs.nvim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'rebelot/kanagawa.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'CRAG666/code_runner.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ThePrimeagen/vim-be-good'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.8'}
Plug 'nvim-lua/plenary.nvim'
call plug#end()

lua << EOF
require("nvim-tree").setup({
    view = {
        width = 30,
        side = "left",
        number=true,
        relativenumber=true
    },
    renderer={
        indent_markers={ enable=true },
        highlight_git=true
    },
    actions={
        open_file={
                quit_on_open=true,
        },
    },
    filters = {
        dotfiles = false,
    },
    git = {
        enable = true,
        ignore = false,
    },
})
EOF

" Add this keybinding with your other mappings
nnoremap <Leader>e :NvimTreeToggle<CR>

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python", "javascript", "cpp", "html", "markdown", "lua", "vim", "vimdoc" },
  highlight = {
    enable = true,              -- false will disable the whole extension
   disable = { "c", "rust" },  -- list of language that will be disabled
  },
}
EOF



lua << EOF
require("notebook-navigator").setup {
    -- Optional configuration options
    split = "horizontal", -- How the REPL should open (horizontal/vertical split)
    repl_command = "jupyter", -- Command to open the REPL (e.g., Jupyter, Python)
}
EOF


" Configure code_runner.nvim
lua << EOF
require('code_runner').setup({
    -- Define how to run files based on their filetype
    filetype = {
        python = "python3 -u",  -- Runs Python scripts using python3
        javascript = "node",    -- Runs JavaScript files using node
        cpp = "g++ % -o %:r && %:r",  -- Compiles C++ files with g++ and runs the resulting executable
        html = "xdg-open",      -- Opens HTML files in the default web browser (Linux example)
    },
})
EOF
colorscheme kanagawa

nnoremap <Leader>tf :Telescope treesitter<C>
nnoremap <leader>nb :!jupytext --to ipynb %<CR>
" Use 'dh' for diffget from the left (HEAD)
nnoremap dh :diffget //2<CR>
" Use 'dl' for diffget from the right (incoming changes)
nnoremap dl :diffget //3<CR>
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap <Leader>t :vsplit<CR>:terminal<CR>
nnoremap <Leader>f :Telescope find_files<CR>
nnoremap <Leader>r :RunCode<CR>
nnoremap <Leader>c :RunClose<CR>
nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
nmap <C-p> <Plug>MarkdownPreviewToggle
nnoremap <leader>a :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>h :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <C-e> :lua require("harpoon.ui").nav_next()<CR>
nmap <silent> gd <Plug>(coc-definition)
nnoremap <silent> K :call CocActionAsync('doHover')<CR>
inoremap <silent><expr> <C-k> CocActionAsync('showSignatureHelp')
nnoremap <C-q> :lua require("harpoon.ui").nav_prev()<CR>
tnoremap <C-h> <C-\><C-N>:TmuxNavigateLeft<CR>
tnoremap <C-j> <C-\><C-N>:TmuxNavigateDown<CR>
tnoremap <C-k> <C-\><C-N>:TmuxNavigateUp<CR>
tnoremap <C-l> <C-\><C-N>:TmuxNavigateRight<CR>
"nb nav"
" Move to the next cell
nnoremap ]h :lua require("notebook-navigator").move_cell("d")<CR>

" Move to the previous cell
nnoremap [h :lua require("notebook-navigator").move_cell("u")<CR>

" Run the current cell
nnoremap <leader>X :lua require("notebook-navigator").run_cell()<CR>

" Run the current cell and move to the next one
nnoremap <leader>x :lua require("notebook-navigator").run_and_move()<CR>




lua << EOF
local alpha = require'alpha'
local dashboard = require'alpha.themes.dashboard'

-- Define the shocked Pikachu ASCII art followed by the text
local header = [[
⢀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⣠⣤⣶⣶
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⢰⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣀⣀⣾⣿⣿⣿⣿
⣿⣿⣿⣿⣿⡏⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿
⣿⣿⣿⣿⣿⣿⠀⠀⠀⠈⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠁⠀⣿
⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠙⠿⠿⠿⠻⠿⠿⠟⠿⠛⠉⠀⠀⠀⠀⠀⣸⣿
⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣴⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⢰⣹⡆⠀⠀⠀⠀⠀⠀⣭⣷⠀⠀⠀⠸⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠈⠉⠀⠀⠤⠄⠀⠀⠀⠉⠁⠀⠀⠀⠀⢿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⢾⣿⣷⠀⠀⠀⠀⡠⠤⢄⠀⠀⠀⠠⣿⣿⣷⠀⢸⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⡀⠉⠀⠀⠀⠀⠀⢄⠀⢀⠀⠀⠀⠀⠉⠉⠁⠀⠀⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿

  ____              _      _   ____                _
 |  _ \  __ _ _ __ (_) ___| | |  _ \ _ __ ___   __| | ___ _ __
 | | | |/ _` | '_ \| |/ _ \ | | | | | '__/ _ \ / _` |/ _ \ '__|
 | |_| | (_| | | | | |  __/ | | |_| | | | (_) | (_| |  __/ |
 |____/ \__,_|_| |_|_|\___|_| |____/|_|  \___/ \__,_|\___|_|




"They did not know it was impossible, so they did it!" - Mark Twain
]]

dashboard.section.header.val = vim.split(header, "\n")
dashboard.section.header.opts.hl = "Title"

-- Rest of your dashboard configuration
dashboard.section.buttons.val = {
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
    dashboard.button("s", "  Settings", ":e $MYVIMRC<CR>"),
    dashboard.button("q", "  Quit", ":qa<CR>"),
}

alpha.setup(dashboard.opts)
EOF
