#!/bin/bash
notContainsElement() {
  local e
  for e in "${@:2}"
  do
    if [ "${e}" == "${1}" ]
    then
      return 1
    fi
  done
  return 0
}

containsElement() {
  local e
  for e in "${@:2}"
  do
    if [ "${e}" == "${1}" ]
    then
      return 0
    fi
  done
  return 1
}
