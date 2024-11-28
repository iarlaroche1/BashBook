#!/bin/bash

# keep running the loop forever to keep processing requests
while true; do
    # ask the user for a request
    echo "Enter request:"
    read request

    # split the input into separate arguments (e.g., command and its params)
    set -- $request  # this turns the request string into $1, $2, etc.

    # store the first argument as the command
    cmd=$1           
    shift            # move everything down, so now $1 is the first argument (after the command)

    case "$cmd" in
        # if the user types 'help', show available commands
        help)
            echo "Available commands:"
            echo "create \$id           - creates a user with the given user id."
            echo "add \$id \$friend      - adds a friend to the user with the given user id."
            echo "post \$sender \$receiver \$message - posts a message on the receiver's wall."
            echo "display \$id          - displays the wall of the user with the given user id."
            echo "help                  - shows this help message."
            ;;
        
        # if the command is 'create', we create a user using the create.sh script
        create)
            id=$1
            # check if a user id was provided
            if [ -z "$id" ]; then
                echo "Error: No user id provided."  # if no ID, show error
                continue  # go back to the start and ask for another request
            fi
            # call the create.sh script to create the user
            ./create.sh "$id"  
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
            echo "nok: bad request"  # error message for anything else
            ;;
    esac
done

