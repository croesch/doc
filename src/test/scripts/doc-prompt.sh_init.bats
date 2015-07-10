#!/usr/bin/env bats

load sut
load helper

@test "reply 'init' as first command when no character is written" {
  COMP_WORDS=( 'doc' '' )
  COMP_CWORD=1
  _important_documents
  containsElement init "${COMPREPLY[@]}"
}

@test "reply 'init' as first command when 'i' is written" {
  COMP_WORDS=( 'doc' 'i' )
  COMP_CWORD=1
  _important_documents
  containsElement init "${COMPREPLY[@]}"
}

@test "reply 'init' as first command when 'in' is written" {
  COMP_WORDS=( 'doc' 'in' )
  COMP_CWORD=1
  _important_documents
  containsElement init "${COMPREPLY[@]}"
}

@test "reply 'init' as first command when 'ini' is written" {
  COMP_WORDS=( 'doc' 'ini' )
  COMP_CWORD=1
  _important_documents
  containsElement init "${COMPREPLY[@]}"
}

@test "reply 'init' as first command when 'init' is written" {
  COMP_WORDS=( 'doc' 'init' )
  COMP_CWORD=1
  _important_documents
  containsElement init "${COMPREPLY[@]}"
}
