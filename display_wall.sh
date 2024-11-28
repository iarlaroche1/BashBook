#!/bin/bash

# get the user id as argument
id=$1

# check if the user directory exists
if [ ! -d "$id" ]; then
    echo "nok: user '$id' does not exist"  # if user doesn't exist, show error
    exit 1  # exit if user is not found
fi

# start and end markers for clarity

cat "$id/wall.txt"  # print the contents of the user's wall


