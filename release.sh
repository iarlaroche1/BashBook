#! /bin/bash

# If the number of arguments is not equal to 1, then this error message is displayed.
if [ -z "$1" ]; then
	echo "Use: ./release.sh lock"
	exit 1
else
	# This removes the symbolic link [lock], allowing other clients
	# to obtain the lock.
	rm "$1"
	exit 0
fi
