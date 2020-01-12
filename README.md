# fzf-ag.vim
Easy to show and handle results of the silver searcher on your vim.

![ag-fzf-demo-anim](https://user-images.githubusercontent.com/41136331/72217584-557d2f00-3573-11ea-9ace-7085d6ccca40.gif)

## Dependencies
- [ggreer/the_silver_searcher](https://github.com/ggreer/the_silver_searcher)
- [junegunn/fzf](https://github.com/junegunn/fzf)
- [junegunn/fzf.vim](https://github.com/junegunn/fzf.vim)
- [perl](https://www.perl.org/)
- [sharkdp/bat](https://github.com/sharkdp/bat) (Optional)

## Install
e.g. Plug
```vim
Plug 'junegunn/fzf.vim'
Plug 'ta-daiki/fzf-ag.vim'
```

## Command
This plugin overrides the original :Ag command of fzf.vim

```vim
:Ag search-keyword [dir1, dir2...]
```

Above command shows a fzf buffer listed ag search results.

In the fzf buffer

|key stroke|behavior                                                                                                                             |
-----------|--------------------------------------------------------------------------------------------------------------------------------------
|\<CR\>    | Open a file under the cursor. The file is opened in the current buffer.                                                             |
|\<C-t\>   | Open a file under the cursor as a new window.                                                                                       |
|\<C-v\>   | Open a file under the cursor in vertical split mode.                                                                                |
|\<C-s\>   | Open a file under the cursor in horizontal split mode.                                                                              |
|\<Tab\>   | Add a file under the cusor to multi-select list. (When multi-select list is not empty. <C-*> command opens all multi-selected files)|
