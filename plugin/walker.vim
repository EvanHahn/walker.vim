let g:code_walk_path = "~/workspace/codewalks"
let g:code_walk_current_walk = ''

" todo: use git / SCM to look up route and append a hash if necessary?
" we need to ideally:
"   store things in a human readable but also machine parseable way (YAML OMG)
function! walker#mark()
  let lineNo = line(".")
  let filePath = expand("%:p")
  let walkFilePath = g:code_walk_path . "/" . g:code_walk_current_walk
  if empty(g:code_walk_current_walk)
    echo "No walk file defined, choose one:\n"
    :call walker#setFile()
  end
  " I do not know how to discard output except by assigning ¯\_(ツ)_/¯
  let _ = execute("! echo "- " . filePath . " +" . lineNo .  >> " . walkFilePath)
endfunction

" this is the quickest and dirtiest way of doing this and easily editing the
" files, there may be better options
function! walker#files()
  " https://vi.stackexchange.com/a/4006
  execute "Explore " . fnameescape(g:code_walk_path)
endfunction

function! walker#setFile()
  let files = split(globpath(g:code_walk_path, "*"), "\n")
  let names = []
  let idx = 0

  for file in files
    :call add(names, idx . "-:" . fnamemodify(file, ":t"))
    let idx = idx + 1
  endfor

  echo join(names, " ")
  call inputsave()
  let chosenIndex = str2nr(input("Enter name: "))
  call inputrestore()

  let chosenFile = get(files, chosenIndex, v:null)
  if chosenFile is v:null
    echo "Invalid index specified"
    return
  else
    let g:code_walk_current_walk = chosenFile
  endif
endfunction

" mappings TODO: move this out to README and have users configure
nmap <silent> <leader>ww :call walker#mark()<CR>