#-*- mode: shell-script;-*-

_add_possible_folder() {
  local directory=$1
  if [ "${directory}" != ".git" ]
  then
    COMPREPLY[i++]=${directory}
  fi
}

_get_possible_folders_for_folder() {
  local folder=$1 cur_word=$2 error_log=/dev/null
  for directory in $(ls "${folder}" 2>${error_log})
  do
    if [[ -d "${folder}/${directory}" && ${directory} == ${cur_word}* ]]
    then
      _add_possible_folder "${directory}"
    fi
  done
  for directory in $(find "${folder}" -mindepth 1 -name "${cur_word}*" -type d -not -path "*/.git/*" -exec basename {} \; 2>${error_log} | sort | uniq -u)
  do
    _add_possible_folder "${directory}"
  done
}

_get_possible_entries_for_folder() {
  local folder=$1 cur_word=$2 error_log=/dev/null
  for entry in $(ls "${folder}" 2>${error_log})
  do
    if [[ ${entry} == ${cur_word}* ]]
    then
      COMPREPLY[i++]=${entry}
    fi
  done
  for entry in $(find "${folder}" -mindepth 1 -name "${cur_word}*" -exec basename {} \; 2>${error_log} | sort | uniq -u)
  do
    COMPREPLY[++i]=${entry}
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
    for word in init add view directory
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
    # pass the storage directory and all arguments except the last one to the method
    local directory=$(_directory_for_folder_list "${DOC_STORAGE_DIRECTORY}" ${COMP_WORDS[@]:2:${#COMP_WORDS[@]}-3})
    _get_possible_folders_for_folder "${directory}" "${cur_word}"
    if [ ${#COMPREPLY[@]} == 0 ]
    then
      COMPREPLY=($(compgen -W "$(find . -type f -printf '%P\n')" -- "${cur_word}"));
    fi
  elif [ $COMP_CWORD -ge 3 ] && [ "${COMP_WORDS[1]}" == "directory" ] && [ "${COMP_WORDS[2]}" == "add" ]
  then
    local directory=$(_directory_for_folder_list "${DOC_STORAGE_DIRECTORY}" ${COMP_WORDS[@]:3:${#COMP_WORDS[@]}-4})
    _get_possible_folders_for_folder "${directory}" "${cur_word}"
  elif [ $COMP_CWORD -ge 2 ] && [ "${COMP_WORDS[1]}" == "view" ]
  then
    local directory=$(_directory_for_folder_list "${DOC_STORAGE_DIRECTORY}" ${COMP_WORDS[@]:2:${#COMP_WORDS[@]}-3})
    _get_possible_entries_for_folder "${directory}" "${cur_word}"
  elif [ $COMP_CWORD -ge 2 ] && [ "${COMP_WORDS[1]}" == "init" ]
  then
    local directory=$(_directory_for_folder_list "$(pwd)" ${COMP_WORDS[@]:2:${#COMP_WORDS[@]}-3})
    _get_possible_folders_for_folder "${directory}" "${cur_word}"
  fi
}

complete -F _important_documents doc
