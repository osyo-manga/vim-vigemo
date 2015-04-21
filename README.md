# vigemo.vim

## Introduction

vigemo.vim is incremental migemo search.

## Installation

[Neobundle](https://github.com/Shougo/neobundle.vim) / [Vundle](https://github.com/gmarik/Vundle.vim) / [vim-plug](https://github.com/junegunn/vim-plug)

```vim
NeoBundle 'osyo-manga/vim-vigemo'
Plugin 'osyo-manga/vim-vigemo'
Plug 'osyo-manga/vim-vigemo'
```

[pathogen](https://github.com/tpope/vim-pathogen)

```
git clone https://github.com/osyo-manga/vim-vigemo ~/.vim/bundle/vim-vigemo
```

##Requirement

* command
 * __[cmigemo](http://www.kaoriya.net/software/cmigemo/)
* vim plugin
 * __[vimproc.vim](https://github.com/Shougo/vimproc.vim)__

## Screencapture

## Usage

```vim
" Start buffer line filtering.
:VigemoSearch

" Example key mapping
nmap <Space>/ <Plug>(vigemo-search)
```

