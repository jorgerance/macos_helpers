#!/usr/bin/env bash

arg=$1
dockPid=$(ps -ef|grep 'Dock.app/Contents/MacOS/Dock'|grep -v grep|awk '{print $2}')
pidLen=`expr "$dockPid" : '.*'`

function p () {
  printf "\n · $@\n"
}

function printHelp () {
  p "Must provide 1 argument: hide | show | kill"
}

if [[ $# -ne 1 ]]; then
  printHelp
  exit
fi

#echo $dockPid
if [[ $pidLen -gt 2 ]]; then
  p "Dock PID: $dockPid"
fi


function runCmd () {
  _cmd="$@"
  eval "$_cmd"
}

function getDockPid () {
  dockPid=$(ps -ef|grep '/System/Library/CoreServices/Dock.app/Contents/MacOS/Dock'|grep -v grep|awk '{print $2}')
}


function killDock () {
  getDockPid
  pidLen=`expr "$dockPid" : '.*'`
  if [[ $pidLen -gt 2 ]]; then
    p "Killing Dock with PID: $dockPid"
    runCmd sudo kill -9 $dockPid
    exit 0
  fi
  p "Dock PID not found. Exiting now!"
  exit 3
}

function hideDock () {
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock autohide-delay -float 1000
  defaults write com.apple.dock no-bouncing -bool TRUE
  killDock
}

function restoreDock () {
  defaults write com.apple.dock autohide -bool false
  defaults delete com.apple.dock autohide-delay
  defaults write com.apple.dock no-bouncing -bool FALSE
  killDock
}


case $arg in
  hide)
    hideDock
    exit $?
  ;;
  show)
    restoreDock
    exit $?
  ;;
  kill)
    killDock
    exit $?
  ;;
  *)
    printHelp
    exit 2
  ;;
esac



