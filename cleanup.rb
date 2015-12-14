#!/usr/bin/ruby

system('supervisorctl shutdown')
system('find . -size 0 -print -delete')
system('killall vlc')
