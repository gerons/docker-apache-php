#!/bin/sh

if [[ $XDEBUG_ENABLED == 0 ]]; then
  rm /usr/local/etc/php/conf.d/xdebug.ini
fi
