Server Script - README
Overview

This script is designed to manage user commands in a simple command-line-based system, where users can perform tasks such as creating a user account, adding friends, posting messages to walls, and displaying the content of a user’s wall. The script operates in an infinite loop, accepting user requests and processing them accordingly.
Key Features

    Help: Displays available commands and their usage.
    Create: Creates a user account and initializes directories for the user’s wall and friends list.
    Add: Adds a friend to the user's friend list.
    Post: Allows a user to post a message to another user’s wall.
    Display: Displays the content of a user’s wall.

Script Breakdown

The script follows a loop that continuously reads user input and processes it using various cases. Here’s how each case works:
1. Help Command

Usage: help

    This command displays a list of available commands and their descriptions.
    It provides information about how to use each command.

2. Create Command

Usage: create <id>

    This command creates a new user with the specified id.
    If the id is empty (-z check), an error message is displayed and the script continues.
    If valid, the following actions are performed:
        A directory named <id> is created.
        Inside this directory:
            An empty file wall.txt is created to store messages posted to the user’s wall.
            An empty file friends.txt is created to store the user's friend list.
        If successful, a success message is shown to the user.
        If any error occurs (e.g., directory creation fails), the create.sh script exits with an error code.

3. Add Command

Usage: add <id> <friend>

    Adds a friend to the specified user.
    Checks if the user (id) exists by verifying the existence of the user’s directory.
    Checks if the friend already exists in the user’s friends.txt file using grep.
        If the friend is already in the list, no action is taken.
        If the user or the friend does not exist, an error message is displayed.
    If valid, the friend is added to the friends.txt file.

4. Post Command

Usage: post <sender> <receiver> <message>

    This command allows a user to post a message to another user’s wall.
    The first argument is assigned to sender and the second to receiver.
    The remaining arguments ($*) are stored as the message.
    The script checks if the sender and receiver exist, and if the sender is a friend of the receiver (using a similar grep check as in the add command).
        If any check fails, an error message is displayed and the process is stopped.
    If all checks pass, the message is appended to the receiver’s wall.txt file.
    The user is alerted that their message has been posted.

5. Display Command

Usage: display <id>

    Displays the contents of the specified user's wall.
    If the id is not provided, the script continues to the next iteration.
    If the id exists, it calls the display_wall.sh script, which checks if the user’s directory exists.
        If the directory exists, the contents of wall.txt are displayed using cat.
        If the user does not exist, the script continues without doing anything.

6. Bad Request

    If the user inputs a command that doesn’t match any of the defined commands (help, create, add, post, or display), a "bad request" message is displayed to the user.

File Structure

When a user is created using the create command, the following file structure is created:

<id>/                # User's directory
  ├── wall.txt       # Stores messages posted to the user's wall
  └── friends.txt    # Stores the user's list of friends

Error Handling

    The script ensures that all commands are executed only when the required files and directories exist.
    If any required file or directory is missing, the script gracefully exits with an error message, without terminating the whole process.

How to Use

    Run the script: Open a terminal and execute the server.sh script.
    Enter commands: Type one of the following commands:
        help – To see a list of available commands.
        create <id> – To create a new user.
        add <id> <friend> – To add a friend to the user’s friend list.
        post <sender> <receiver> <message> – To post a message on another user’s wall.
        display <id> – To display the contents of the user’s wall.
