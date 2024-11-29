#!/bin/bash
#create.sh
echo "DEBUG create script running"
# check if no arguments are provided
if [ $# -eq 0 ]; then
    echo "nok: no identifier provided"  # if no ID is given, show error
    exit 1  # exit the script with an error code
fi

id=$1  # store the first argument (user ID) in 'id'

# check if a directory with the user ID already exists
if [ -d "$id" ]; then 
	#echo "DEBUG nok: user already exists"
    #./client.sh "nok: user already exists"
    exit 1  # exit the script with an error code
fi

# create a new directory for the user
mkdir "$id"

# create empty wall and friends text files for the user
touch "$id/wall.txt"
touch "$id/friends.txt"

exit 0 # success
#echo "DEBUG ok: user created!"
#./client.sh "ok: user created!" # send success message to client

