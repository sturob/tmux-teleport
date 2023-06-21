#!/usr/bin/env bash

url="$1"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	xdg-open $url
elif [[ "$OSTYPE" == "darwin"* ]]; then
	open $url
elif [[ "$OSTYPE" == "cygwin" ]]; then
	cygstart $url
elif [[ "$OSTYPE" == "msys" ]]; then
	start $url
elif [[ "$OSTYPE" == "freebsd"* ]]; then
	xdg-open $url
elif [[ "$OSTYPE" == "openbsd"* ]]; then
	xdg-open $url
elif [[ "$OSTYPE" == "cros"* ]]; then
	garcon-url-handler $url
else
	echo "unknown: $OSTYPE"
fi
