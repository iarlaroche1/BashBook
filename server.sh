#!/bin/bash
#server.sh
# called in client with ./server.sh "$req" "$id" "$args"
# keep running the loop forever to keep processing requests
while true; do

    cmd=$1
    id=$2 
    args=$3
    
    echo "SERVER: cmd is $cmd "
    echo "SERVER: id is $id "
    echo "SERVER: args is $args "
            
    #shift            # move everything down, so now $1 is the first argument (after the command)
	
    case "$cmd" in
        # if the user types 'help', show available commands
        help)
            echo "Available commands:"
            echo "create \$id           - creates a user with the given user id."
            echo "add \$id \$friend      - adds a friend to the user with the given user id."
            echo "post \$sender \$receiver \$message - posts a message on the receiver's wall."
            echo "display \$id          - displays the wall of the user with the given user id."
            echo "help                  - shows this help message."
         	
           # continue
           exit 0
            ;;
            
        
        # if the command is 'create', we create a user using the create.sh script
        create)
            #id=$1
           echo "DEBUG create called in server "
            # check if a user name was provided
            if [ -z "$args" ]; then #changed from $id to $args
                echo "nok: No user id provided."  # if no ID, show error
                echo "nok: bad request"
                exit 1  # return a failure message to client
            fi
            # Call the create.sh script to create the user
            ./create.sh "$args"
        
            # Capture the exit status of create.sh
            status=$?

            # Based on the exit status, send an appropriate message back to client.sh
            if [ "$status" -eq 0 ]; then
                echo "ok: user created!"  # Success message
                exit 0
            else
                echo "nok: user already exists"  # Failure message
                exit 1
            fi
            ;;
        
        # if the command is 'add', add a friend to the user's friend list
        add)
            id=$1
            friend=$2
            # check if both user ID and friend ID are given
            if [ -z "$id" ] || [ -z "$friend" ]; then
                echo "nok: bad request"  # if anything is missing, show an error
                continue  # go back and prompt for a new request
            fi
            # call the add_friend.sh script to add the friend
            ./add_friend.sh "$id" "$friend"
            ;;
        
        # if the command is 'post', we post a message on the receiver's wall
        post)
            sender=$1
            receiver=$2
            shift 2  # skip the sender and receiver, now we have the message
            message="$*"  # capture the rest as the message text
            
            # check if all required info is there: sender, receiver, and message
            if [ -z "$sender" ] || [ -z "$receiver" ] || [ -z "$message" ]; then
                echo "nok: bad request"  # if any part is missing, show error
                continue  # skip and ask for another input
            fi
            # call the post_message.sh script to post the message
            ./post_message.sh "$sender" "$receiver" "$message" 
            ;;
        
        # if the command is 'display', show the user's wall
        display)
            id=$1
            # check if a user ID is given
            if [ -z "$id" ]; then
                echo "nok: bad request"  # show error if no user ID
                continue  # skip and ask for another input
            fi
            # call display_wall.sh to show the wall of the user
            ./display_wall.sh "$id" 
            ;;
        
        # if the command doesn't match any of the above, show bad request
        *)
            echo "SERVER nok: bad request"  # error message for anything else
            ;;
    esac
done

