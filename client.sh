#!/bin/bash

# If the number of arguments is not equal to 1, return an error message to the user and crash.
if [ $# -ne 1 ]; then
	echo "The parameters are: client id"
	exit 1
else
	# Stores the provided id into a variable.
       	id=$1

	# if the user id pipe doesnt exist, create it.
	if [[ -p "$id".pipe ]]; then
		mkfifo "$id".pipe
	fi
	# When the user kills the client side using (Ctrl-C), their pipe will be deleted aswell
	trap "rm -f $id.pipe & exit 1" SIGINT	
	# Event loop to continuously get requests from the user.
	while true; do
		# display a barebones help message for the user to know what commands are valid.
		echo "Enter request: [help | create | add | post | display]"

		# Gets the stdin from the user and sets the arguments [$1, $2, etc] to those gathered
		# from the stdin.
		read request
		set -- $request
		
		# The actual request is obtained from the first arguement.
		cmd=$1
		case "$cmd" in
			help)
				echo 
				echo $cmd > $server.pipe
				./server.sh $id
				echo 
				;;
			create)
				# sends the required parameters into the server's pipe.
				#
				# the sole parameter the server takes in is the id so that it can
				# correctly identify the user.
				#
				# The server reponse is retrived by displaying the recent contents
				# of the user's pipe and storing that into a variable
				
				echo $cmd $id > $server.pipe
				./server.sh $id
				response=$(cat "$id".pipe)
				
				# String matching the reponses from the server to ensure that the 
				# message is user friendly.


				if [ "$response" = "ok: user created!" ]; then
				       echo "Success: user created!"
			        elif [ "$response" = "nok: user already exists" ]; then
					echo "ERROR: user already exists!"
				else
					echo "UNREACHABLE"
				fi	       
				# for a newline.
				echo
				;;
			add)
				friend=$2
				# sends the required parameters into the server's pipe.
				#
				# the sole parameter the server takes in is the id so that it can
				# correctly identify the user.
				#
				# The server reponse is retrived by displaying the recent contents
				# of the user's pipe and storing that into a variable

				echo $cmd $id $friend > $server.pipe
				./server.sh $id
				response=$(cat "$id".pipe)
				echo 
				echo $response
				echo 
				;;
			post)
				sender=$id
				receiver=$2
				shift 2
				message="$*"
				
				# sends the required parameters into the server's pipe.
				#
				# the sole parameter the server takes in is the id so that it can
				# correctly identify the user.
				#
				# The server reponse is retrived by displaying the recent contents
				# of the user's pipe and storing that into a variable
				
				echo $cmd $sender $receiver $message > $server.pipe
				./server.sh $id
				response=$(cat "$id".pipe)
				
				echo
				echo $response
				echo 
				;;
			display)

				# sends the required parameters into the server's pipe.
				#
				# the sole parameter the server takes in is the id so that it can
				# correctly identify the user.
				#
				# The server reponse is retrived by displaying the recent contents
				# of the user's pipe and storing that into a variable
				
				echo $cmd $id > $server.pipe
				./server.sh $id
				response=$(cat "$id".pipe)
				
				# A bit of distance before and after displaying the wall for
				# user convenience.
				echo 
				echo $response
				echo 
				;;
			*)
				echo "improper request."
				;;
		esac
	done
fi
