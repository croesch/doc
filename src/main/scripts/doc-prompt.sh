#-*- mode: shell-script;-*-

_important_documents() {
  local i=0 cur_word=${COMP_WORDS[COMP_CWORD]} prev_word=${COMP_WORDS[COMP_CWORD-1]} word
  if [ $COMP_CWORD == 1 ]
  then
    for word in add view directory
    do
      if [[ ${word} == ${cur_word}* ]]
      then
        COMPREPLY[i++]=${word}
      fi
    done
  elif [ $COMP_CWORD == 2 ] && [ "${prev_word}" == "directory" ]
  then
    COMPREPLY[i++]="add"
  elif [ $COMP_CWORD == 2 ] && [ "${prev_word}" == "add" ]
  then
    for directory in $(ls "${DOC_STORAGE_DIRECTORY}")
    do
      if [[ -d "${DOC_STORAGE_DIRECTORY}/${directory}" && ${directory} == ${cur_word}* ]]
      then
        COMPREPLY[i++]=${directory}
      fi
      for directory in $(find "${DOC_STORAGE_DIRECTORY}" -type d -exec basename {} \; | sort | uniq -u)
      do
        if [[ ${word} == ${cur_word}* ]]
        then
          COMPREPLY[++i]=${directory}
        fi
      done
    done
  fi
}

complete -F _important_documents doc
