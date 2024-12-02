#!/bin/bash

# If the number of arguments is not equal to 1, return an error message to the user and crash.
if [ $# -ne 1 ]; then
	echo "The parameters are: client id"
	exit 1
else
	# Stores the provided id into a variable.
       	id=$1

	# if the user id pipe doesnt exist, create it.
	if [[ ! -p "$id".pipe ]]; then
		mkfifo "$id".pipe
	fi

	# The exitcommand is set to a variable to allow configuration during the loop to adjust to
	# different scenarios [if the lock still exists or not.]
	#
	# This assumes that the lock hasnt been created yet, therefore this is a standard command
	# to kill the pipe and close the program when the user is finished.
	#
	# The exitcommand is used in the trap command to have alternative functionality for (Ctrl-C)
	exitcommand="rm "$id".pipe & exit 1"
	
	# When the user kills the client side using (Ctrl-C), their pipe will be deleted aswell
	# and the lock will be forcefully released [if it exists].
		
	trap "$exitcommand" SIGINT	
	
	# Event loop to continuously get requests from the user.
	while true; do
		
		# If the lock is still in use when the user decides to quit/log off, the exitcommand
		# will include the functionality to forcefully remove the server.lock
		if [ -L server.lock ]; then
			exitcommand="rm "$id".pipe & ./release.sh server.lock & exit 1"
		else
			exitcommand="rm "$id".pipe & exit 1"
		fi
		
		# display a barebones help message for the user to know what commands are valid.
		echo "Enter request: [help | create | add | post | display | quit]"

		# Gets the stdin from the user and sets the arguments [$1, $2, etc] to those gathered
		# from the stdin.
		read request
		set -- $request
		
		# This sets [server.lock] to be a symbolic link if it isnt one already.
		# If it is a s.l. then it acts as a lock and can't be acquired until it is released
		# [The link is removed].

		./acquire.sh server.pipe server.lock

		# The actual request is obtained from the first arguement.
		cmd=$1
		case "$cmd" in
			# Allows the user to quit, and performs the necessary closing actions.
		        quit)
				rm "$id".pipe
				./release.sh server.lock
				exit 0
				;;	
			# if the user types 'help', show available commands
			help)
				echo
				echo "available commands:"
				echo "create           	- creates a user with the id currently in use."
				echo "add \$friend  		- adds a friend to the user currently online."
				echo "post \$receiver \$message - posts a message on the receiver's wall."
				echo "display          	- displays the wall of the logged in user."
				echo "help                  	- shows this help message."
				echo "quit			- quits the program."
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
				
				echo $id $cmd $id > server.pipe
				#./server.sh $id
				response=$(cat "$id".pipe)
				
				# String matching the reponses from the server to ensure that the 
				# message is user friendly.

				echo
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

				echo $id $cmd $id $friend > server.pipe
				response=$(cat "$id".pipe)

				echo 
				
				# String matching the reponses from the server to ensure that the 
				# message is user friendly.
				if [ "$response" = "user: '$friend' does not exist" ]; then
					echo "ERROR: user: '$friend' does not exist"
				elif [ "$response" == "nok: user: '$id' does not exist" ]; then
					echo "ERROR: you dont have an account, please create one."
				elif [ "$response" == "nok: '$friend' is already a friend" ]; then
					echo "ERROR: '$friend' is already a friend."
				else
					echo "SUCCESS: '$friend' is now added."
				fi

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
				
				echo $id $cmd $sender $receiver $message > server.pipe
				#./server.sh $id
				response=$(cat "$id".pipe)
			
				echo 
				# String matching the reponses from the server to ensure that the 
				# message is user friendly.
				if [ "$response" = "nok: user '$sender' does not exist" ]; then
					echo "ERROR: you dont have an account, please create one."
				elif [ "$response" = "nok: user '$receiver' does not exist" ]; then
					echo "ERROR: user '$receiver' does not exist"
				elif [ "$response" = "nok: user '$sender' is not a friend of '$receiver'" ]; then
					echo "ERROR: '$receiver' does not have you as a friend."
				else
					echo "SUCCESS: message posted!"
				fi

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
				
				echo $id $cmd $id > server.pipe
				#./server.sh $id
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

		# This simply releases the lock by deleting its representation: [The symbolic link]
		 ./release.sh server.lock
	done
fi
