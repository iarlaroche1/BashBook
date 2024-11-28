#!/bin/bash

# get user id and friend id as arguments
id=$1
friend=$2

# check if the user directory for $id exists
if [ ! -d "$id" ]; then
    echo "nok: user '$id' does not exist"  # if the user doesn't exist, show error
    exit 1  # exit the script if user doesn't exist
fi

# check if the friend directory for $friend exists
if [ ! -d "$friend" ]; then
    echo "nok: user '$friend' does not exist"  # if the friend doesn't exist, show error
    exit 1  # exit the script if friend doesn't exist
fi

# check if $friend is already in $id's friends list
if grep -q "^$friend$" "$id/friends.txt"; then
    echo "nok: '$friend' is already a friend"  # if $friend is already a friend, show error
    exit 1  # exit the script if the friend already exists
fi

# add $friend to $id's friends list
echo "$friend" >> "$id/friends.txt"  # append $friend to the friends file

# success message
echo "ok: friend added!"  # let the user know everything went fine

