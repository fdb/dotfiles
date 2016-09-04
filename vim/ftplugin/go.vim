" Go run and go fmt
map ,r :w<cr>:!go run %<cr>
map ,f :w<cr>:!go fmt %<cr>:e!<cr>
:autocmd BufWritePre *.go silent :GoImports
