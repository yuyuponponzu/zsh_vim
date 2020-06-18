if &compatible
  set nocompatible
endif
filetype plugin indent on
syntax enable
set t_Co=256

set smarttab
set expandtab
set virtualedit=block

set ignorecase
set smartcase
set incsearch
set nohlsearch
set wrapscan

set list
set number
set listchars=tab:>-

set ambiwidth=double
set laststatus=2
set showtabline=2

set clipboard=unnamed

set backspace=eol,indent,start

set wildmenu
set wildmode=list:full
set wildignore=*.o,*.obj,*.pyc,*.so,*.dll
let g:python_highlight_all = 1
"自動文字数カウント
augroup WordCount
    autocmd!
    autocmd BufWinEnter,InsertLeave,CursorHold * call WordCount('char')
augroup END
let s:WordCountStr = ''
let s:WordCountDict = {'word': 2, 'char': 3, 'byte': 4}
function! WordCount(...)
    if a:0 == 0
        return s:WordCountStr
    endif
    let cidx = 3
    silent! let cidx = s:WordCountDict[a:1]
    let s:WordCountStr = ''
    let s:saved_status = v:statusmsg
    exec "silent normal! g\<c-g>"
    if v:statusmsg !~ '^--'
        let str = ''
        silent! let str = split(v:statusmsg, ';')[cidx]
        let cur = str2nr(matchstr(str, '\d\+'))
        let end = str2nr(matchstr(str, '\d\+\s*$'))
        if a:1 == 'char'
            " ここで(改行コード数*改行コードサイズ)を'g<C-g>'の文字数から引く
            let cr = &ff == 'dos' ? 2 : 1
            let cur -= cr * (line('.') - 1)
            let end -= cr * line('$')
        endif
        let s:WordCountStr = printf('%d/%d', cur, end)
    endif
    let v:statusmsg = s:saved_status
    return s:WordCountStr
endfunction
"------- plugins --------"
runtime macros/matchit.vim

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" gaでテキスト揃え
"Plug 'junegunn/vim-easy-align'

" Pythonの自動補完
"Plug 'davidhalter/jedi-vim'

" KillRing的なやつl
Plug 'LeafCage/yankround.vim'

" vで選択範囲を拡大、C-vで選択範囲を戻す
"Plug 'terryma/vim-expand-region'

" C--2回押しで選択範囲をまとめてコメントアウト
"Plug 'tomtom/tcomment_vim'

" gxでカーソル下のURLをブラウザで開く(URLでなければ検索結果を開く)
"Plug 'tyru/open-browser.vim'

" テキストを囲うものを様々に編集l
Plug 'tpope/vim-surround'

" 閉じカッコの自動挿入
"Plug 'cohama/lexima.vim'

" インデントの可視化
Plug 'Yggdroot/indentLine'

" 候補絞り込み型インターフェース
"Plug 'kien/ctrlp.vim'
" CtrlPの拡張プラグイン. 関数検索
"Plug 'tacahiroy/ctrlp-funky'

" CtrlPの拡張プラグイン. コマンド履歴検索
"Plug 'suy/vim-ctrlp-commandline'

" CtrlPの拡張プラグイン 3つの機能が同梱
"Plug 'sgur/ctrlp-extensions.vim'

" vimからagを利用する
Plug 'rking/ag.vim'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" vimtex用
Plug 'lervag/vimtex'

" Initialize plugin system
call plug#end()


"------- plugin settings --------"
" ctrlp
" let g:ctrlp_match_window = 'order:ttb,min:20,max:20,results:100'
" .(ドット)から始まるファイルも検索対象にする
let g:ctrlp_show_hidden = 1
" ファイル検索のみ使用
let g:ctrlp_types = ['fil'] 
" CtrlPの拡張指定
let g:ctrlp_extensions = ['funky', 'commandline', 'yankring'] 
"C-pでCtrlPMenuが起動するように
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMenu'
" CtrlPCommandLineの有効化
command! CtrlPCommandLine call ctrlp#init(ctrlp#commandline#id())
" CtrlPFunkyの有効化
let g:ctrlp_funky_matchtype = 'path' 
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files           = 100000
let g:ctrlp_mruf_max            = 500
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.?(git|hg|svn|cache|emacs\.d|node_modules)$',
  \ 'file': '\v\.(exe|so|dll|dmg|tar|gz|c4d|DS_Store|zip|mtl|lxo|psd|ai|eps|pdf|aep|jpe?g|png|gif|tif|swf|svg|obj|fbx|mov|mp[3-4])$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" jedi-vim
" docstringポップアップを無効化
autocmd FileType python setlocal completeopt-=preview

" indentLine
" 任意のファイルタイプで無効化する
let g:indentLine_fileTypeExclude = ['help', 'markdown']

" .vim/after/ftplugin/python.vim

if exists('b:did_ftplugin_python')
    finish
endif
let b:did_ftplugin_python = 1

"setlocal foldmethod=indent
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab



" - af: a function
" - if: inner function
" - ac: a class
" - ic: inner class

" this plugin has aditional key-bind
"  -  '[pf', ']pf': move to next/previous function
"  -  '[pc', ']pc': move to next/previous class
xmap <buffer> af <Plug>(textobj-python-function-a)
omap <buffer> af <Plug>(textobj-python-function-a)
xmap <buffer> if <Plug>(textobj-python-function-i)
omap <buffer> if <Plug>(textobj-python-function-i)
xmap <buffer> ac <Plug>(textobj-python-class-a)
omap <buffer> ac <Plug>(textobj-python-class-a)
xmap <buffer> ic <Plug>(textobj-python-class-i)
omap <buffer> ic <Plug>(textobj-python-class-i)

setlocal omnifunc=jedi#completions

if version < 600
  syntax clear
elseif exists('b:current_after_syntax')
  finish
endif

" We need nocompatible mode in order to continue lines with backslashes.
" Original setting will be restored.
let s:cpo_save = &cpo
set cpo&vim

syn match pythonOperator "\(+\|=\|-\|\^\|\*\)"
syn match pythonDelimiter "\(,\|\.\|:\)"
syn keyword pythonSpecialWord self

hi link pythonSpecialWord    Special
hi link pythonDelimiter      Special

let b:current_after_syntax = 'python'

let &cpo = s:cpo_save
unlet s:cpo_save


















"エンコーディング
"GUI版使ってるなら無効にした方がいいらしいです
set encoding=utf-8
scriptencoding utf-8

"vi互換をオフ
"これ記述しなくても互換はオフらしいです

"カーソル位置表示
set ruler
"行番号表示
set number

"色
set background=dark
"カラーテーマは入れたら有効にしてください
let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid

"行番号の色や現在行の設定
autocmd ColorScheme * highlight LineNr ctermfg=12
highlight CursorLineNr ctermbg=4 ctermfg=0
set cursorline
highlight clear CursorLine

"シンタックスハイライト
syntax enable

"オートインデント
set autoindent

"タブをスペースに変換
set expandtab
set smarttab

"ビープ音すべてを無効にする
set visualbell t_vb=

"長い行の折り返し表示
set wrap

"検索設定
"インクリメンタルサーチしない
set noincsearch
"ハイライト
set hlsearch
"大文字と小文字を区別しない
set ignorecase
"大文字と小文字が混在した検索のみ大文字と小文字を区別する
set smartcase
"最後尾になったら先頭に戻る
set wrapscan
"置換の時gオプションをデフォルトで有効にする
set gdefault


"不可視文字の設定
set list
set listchars=tab:>-,eol:↲,extends:»,precedes:«,nbsp:%

"コマンドラインモードのファイル補完設定
set wildmode=list:longest,full

"入力中のコマンドを表示
set showcmd

"クリップボードの共有
set clipboard=unnamed,autoselect

"カーソル移動で行をまたげるようにする
set whichwrap=b,s,h,l,<,>,~,[,]

"バックスペースを使いやすく
set backspace=indent,eol,start
set nrformats-=octal

set pumheight=10

"対応する括弧に一瞬移動
set showmatch
set matchtime=1
source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張する

"ウィンドウの最後の行もできるだけ表示
set display=lastline

"変更中のファイルでも保存しないで他のファイルを表示する
set hidden

"バックアップファイルを作成しない
set nobackup
"バックアップファイルのディレクトリ指定
set backupdir=$HOME/.vim/backup
"アンドゥファイルを作成しない
set noundofile
"アンドゥファイルのディレクトリ指定
set undodir=$HOME/.vim/backup
"スワップファイルを作成しない
set noswapfile



""""""""""""""""""""""""""""""
"aで行頭にsで行末に移動
nnoremap a 0
nnoremap s $
"zでプログラムの最初にxでプログラムの最後に移動
nnoremap z gg
nnoremap x G

"ノーマルモードのまま改行
nnoremap <CR> A<CR><ESC>

"ノーマルモードのままバックスペース
nnoremap <backspace> <ESC><backspace><ESC>

"ノーマルモードのままスペース
nnoremap <space> i<space><esc>

nnoremap :zc :set foldmethod=marker

"挿入モード時にCtrl+Eでノーマルモードへ
inoremap <C-E> <ESC>
nnoremap <C-E> i

nnoremap f :'s,'e

"rだけでリドゥ
nnoremap r <C-r>

nnoremap <C-c> <C-d>

"ESCキー2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

"ペースト時に自動インデントで崩れるのを防ぐ
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

filetype plugin indent on
let g:tex_fast="mr"
"let g:latex_latexmk_options = '-pdf'
