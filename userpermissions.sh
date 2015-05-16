#!/bin/bash

/sbin/setuser nzbdrone
usermod -u 108 nzbdrone
usermod -g 100 nzbdrone
usermod -d /home nzbdrone
chown -R nzbdrone:users /home
