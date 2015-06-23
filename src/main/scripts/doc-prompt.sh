#-*- mode: shell-script;-*-

_get_possible_folders_for_folder() {
  local folder=$1 cur_word=$2 error_log=/dev/null
  for directory in $(ls "${folder}" 2>${error_log})
  do
    if [[ -d "${folder}/${directory}" && ${directory} == ${cur_word}* ]]
    then
      COMPREPLY[i++]=${directory}
    fi
  done
  for directory in $(find "${folder}" -mindepth 1 -name "${cur_word}*" -type d -exec basename {} \; 2>${error_log} | sort | uniq -u)
  do
    COMPREPLY[++i]=${directory}
  done
}

_directory_for_folder_list() {
  local error_log=/dev/null
  if [ $# == 1 ]
  then
    echo $1
  elif [ -d "${1}/${2}" ]
  then
    echo $(_directory_for_folder_list "${1}/${2}" "${@:3}")
  else
    for directory in $(find "${1}" -name "${2}" -type d 2>${error_log})
    do
      echo $(_directory_for_folder_list "${directory}" "${@:3}")
      break
    done
  fi

}

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
  elif [ $COMP_CWORD -ge 2 ] && [ "${COMP_WORDS[1]}" == "add" ]
  then
    local directory=$(_directory_for_folder_list "${DOC_STORAGE_DIRECTORY}" ${COMP_WORDS[@]:2:${#COMP_WORDS[@]}-3})
    _get_possible_folders_for_folder "${directory}" "${cur_word}"
    if [ ${#COMPREPLY[@]} == 0 ]
    then
      COMPREPLY=($(compgen -W "$(find . -type f -printf '%P\n')" -- "${cur_word}"));
    fi
  fi
}

complete -F _important_documents doc
