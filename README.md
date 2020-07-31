
# vim-vimscript\_tagfunc

This plugin provides to set `&tagfunc` for Vim script.
the `&tagfunc` can jump to following:

* script function
* autoload function
* global function
* user-defined command
* highlight

## Usage

```
function! s:xxx()

    call s:yyy() " Typing Ctrl-] on 'yyy',
                 " you can jump to the define of s:yyy()
endfunction                                         |
                                                    |
~snip~                                              |
                                                    |
function! s:foo()              <--------------------+
```

## Installation

This is an example of installation using [vim-plug](https://github.com/junegunn/vim-plug).

```
Plug 'rbtnn/vim-vimscript_tagfunc'
```

## License

Distributed under MIT License. See LICENSE.
