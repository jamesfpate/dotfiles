" Simple test for mini.pick speed
function! TestPickSpeed()
  let start = reltime()
  lua require('mini.pick').builtin.files()
  let elapsed = reltimestr(reltime(start))
  echo "Time to open picker: " . elapsed . " seconds"
endfunction

" Map it to a key
nnoremap <leader>T :call TestPickSpeed()<CR>