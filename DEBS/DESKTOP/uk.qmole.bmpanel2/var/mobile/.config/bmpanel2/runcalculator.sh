#!/bin/bash
herbstclient use Desk
xpause &
_PS=`ps ax | awk '{print $5}' | grep -v grep | grep galculator | wc -l`
if [ $_PS -eq 0 ] ; then
  galculator &
fi


