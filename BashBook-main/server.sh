#!/bin/bash

# Keep looping to process commands from the clients.
while true; do
   

    # This traps (Ctrl-c) to terminate the script and remove the pipe.
    trap "rm server.pipe & exit 1" SIGINT
    # This creates the server side pipe for communication with the clients, if it doesn't exist already.
    if [[ ! -p server.pipe ]]; then
	    mkfifo server.pipe
    fi
    
    # The request is obtained from server.pipe as it acts as a place for users to store their requests.
    read request < server.pipe

    # split the input into separate arguments (e.g., command and its params)
    set -- $request  # this turns the request string into $1, $2, etc.

   # The user's id is obtained from the first parameter and shall be used to identify the correct pipe.
    id=$1	
    shift

    # store the first argument as the command
    cmd=$1
    shift            # move everything down, so now $1 is the first argument (after the command)
    case "$cmd" in
        # if the user types 'help', show available commands
        # if the command is 'create', we create a user using the create.sh script
        create)
            id=$1
            # check if a user id was provided
            if [ -z "$id" ]; then
                echo "Error: No user id provided." > "$id".pipe  # if no ID, forward error to user pipe
	    else
            # call the create.sh script to create the user and forwards the output to the user's pipe
	    echo $(./create.sh $id) > "$id".pipe
	    fi
	    ;;
        
        # if the command is 'add', add a friend to the user's friend list
        add)
            id=$1
            friend=$2
            # check if both user ID and friend ID are given
            if [ -z "$id" ] || [ -z "$friend" ]; then
                echo "nok: bad request" > "$id".pipe  # if anything is missing, forward an error to the user's pipe
	    else
            # call the add_friend.sh script to add the friend. Output is forwarded to the user pipe.
	    echo $(./add_friend.sh "$id" "$friend") > "$id".pipe
	    fi
	    ;;
        
        # if the command is 'post', we post a message on the receiver's wall
        post)
            sender=$1
            receiver=$2
            shift 2  # skip the sender and receiver, now we have the message
            message="$*"  # capture the rest as the message text
            
            # check if all required info is there: sender, receiver, and message
            if [ -z "$sender" ] || [ -z "$receiver" ] || [ -z "$message" ]; then
                echo "nok: bad request" > "$id".pipe  # if any part is missing, show error to user pipe
            else
            # call the post_message.sh script to post the message
	    echo $(./post_message.sh "$sender" "$receiver" "$message") > "$id".pipe
	    fi
	    ;;
        
        # if the command is 'display', show the user's wall
        display)
            id=$1
            # check if a user ID is given
            if [ -z "$id" ]; then
                echo "nok: bad request"  # show error if no user ID
	    else
	    # call display_wall.sh to show the wall of the user which will be forwarded to the user's pipe (to be handled in the client side).
	    echo $(./display_wall.sh "$id") > "$id".pipe
	    fi
	    ;;
        
        # if the command doesn't match any of the above, show bad request
        *)
            echo "nok: bad request" # error message for anything else
            ;;
    esac
done 
