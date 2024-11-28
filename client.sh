#!/bin/bash

# should the client authenticate the format and request type ? For now, I think that as long as the server script handles the processing of the arguments provided by client, it will be the smoothest 
id="$1"

if [ "$#" -lt 1 ];then # shuld only take one argument upon creation
    echo "nok: user '$id' not passed to client.sh"  # if no parameter, exit
    exit 1  # exit if user is not found
fi

while true; do

    # ask the user for a request
    echo "Enter request in form 'req args':"
    read request #The read command takes the user input and splits the string into fields, assigning each new word to an argument.

    # split the input into separate arguments (e.g., command and its params)
    set -- $request  # this turns the request string into $1, $2, etc.

    # store the first argument as the command before shifting
    req=$1  
    
	shift # move everything down 
	# need to check if format is ok
	# send req id args to server

	args="$*" # the rest of the text are the arguments (e.g in the case of a message being posted, 				consisting of multiple words". this wont include the rquest itself as it has been shifted
	
	# call server with arguments
	   valid=$(./server.sh "$req" "$id" "$args")
	
	
	echo " ERROR CHECK IN CLIENT valid = $valid" #debug
	# check what message the scrripts return
	#for create
	if [ "$valid" == "ok: user created!" ]; then
        echo "SUCCESS: user created!"
        
    elif [ "$valid" == "nok: user already exists" ]; then
        echo "ERROR: user already exists"
        fi
done
