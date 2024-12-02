#! /bin/bash

# If the number of parameters is not equal to 2,
# this help message will be displayed.

if [ $# -ne 2 ]; then
	echo "Use: ./acquire.sh pipe lock_name";
	exit 1
else
	# If the given parameter is a symbolic link, this enters a suspended state.
	# if the lock [symbolic link] exists, then this is loop
	# is ran, to sleep for a second to ensure that no other client can acquire
	# this lock.
	while  ! ln -s "$1" "$2" >/dev/null; do
		sleep 1
	done
	
	exit 0
fi
