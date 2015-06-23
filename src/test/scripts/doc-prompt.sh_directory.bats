#!/usr/bin/env bats

load sut
load helper

@test "reply 'directory' as first command when no character is written" {
  COMP_WORDS=( 'doc' '' )
  COMP_CWORD=1
  _important_documents
  containsElement directory "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'directory' as first command when 'd' is written" {
  COMP_WORDS=( 'doc' 'd' )
  COMP_CWORD=1
  _important_documents
  containsElement directory "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'directory' as first command when 'di' is written" {
  COMP_WORDS=( 'doc' 'di' )
  COMP_CWORD=1
  _important_documents
  containsElement directory "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'directory' as first command when 'dir' is written" {
  COMP_WORDS=( 'doc' 'dir' )
  COMP_CWORD=1
  _important_documents
  containsElement directory "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'directory' as first command when 'dire' is written" {
  COMP_WORDS=( 'doc' 'dire' )
  COMP_CWORD=1
  _important_documents
  containsElement directory "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'directory' as first command when 'direc' is written" {
  COMP_WORDS=( 'doc' 'direc' )
  COMP_CWORD=1
  _important_documents
  containsElement directory "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'directory' as first command when 'direct' is written" {
  COMP_WORDS=( 'doc' 'direct' )
  COMP_CWORD=1
  _important_documents
  containsElement directory "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'directory' as first command when 'directo' is written" {
  COMP_WORDS=( 'doc' 'directo' )
  COMP_CWORD=1
  _important_documents
  containsElement directory "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'directory' as first command when 'director' is written" {
  COMP_WORDS=( 'doc' 'director' )
  COMP_CWORD=1
  _important_documents
  containsElement directory "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'directory' as first command when 'directory' is written" {
  COMP_WORDS=( 'doc' 'directory' )
  COMP_CWORD=1
  _important_documents
  containsElement directory "${COMPREPLY[@]}"
  [ $? ]
}
