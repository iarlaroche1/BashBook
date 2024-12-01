#!/bin/bash

# check if no arguments are provided
if [ $# -eq  0 ]; then
    echo "nok: no identifier provided"  # if no ID is given, show error
    exit 1  # exit the script with an error code
fi

id=$1  # store the first argument (user ID) in 'id'

# check if a directory with the user ID already exists
if [ -d "$id" ]; then 
    echo "nok: user already exists"  # if user already exists, show error
    exit 1  # exit the script with an error code
fi

# create a new directory for the user
mkdir "$id"

# create empty wall and friends text files for the user
touch "$id/wall.txt"
touch "$id/friends.txt"

echo "ok: user created!"  # show success message

