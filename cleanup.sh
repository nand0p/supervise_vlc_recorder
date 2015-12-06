#!/bin/bash

supervisorctl shutdown
find . -size 0 -print -delete
killall vlc
