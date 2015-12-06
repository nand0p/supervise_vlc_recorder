#!/bin/bash

supervisorctl shutdown
find . -size 0 -print -delete
ps -ef | grep vlc | awk '{print $2}' | xargs kill -9
