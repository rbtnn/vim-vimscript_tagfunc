
# vim-vimscript\_tagfunc

This plugin supports Vim and Neovim and provides to set `&tagfunc` for Vim script.
The `&tagfunc` can jump to following:

* script function
* autoload function
* global function
* user-defined command
* highlight
* export def or const (Vim9 script only)

## Usage

```
function! s:xxx()

    call s:yyy() " Typing Ctrl-] on 'yyy',
                 " you can jump to the definition of s:yyy()
endfunction                                            |
                                                       |
~snip~                                                 |
                                                       |
function! s:yyy()              <-----------------------+
```

```
import * as X from './x.vim'

~snip~

def s:main()
    var v = X.Get() # Typing Ctrl-] on 'X.Get',
                    # you can jump to the definition of 'export def Get' or 'export const Get'
endfunction                                                    |
                                                               |
                                                               |
                                                               |
# ./x.vim                                                      |
                                                               |
export def Get()              <--------------------------------+
```

## Installation

This is an example of installation using [vim-plug](https://github.com/junegunn/vim-plug).

```
Plug 'rbtnn/vim-vimscript_tagfunc'
```

## License

Distributed under MIT License. See LICENSE.

