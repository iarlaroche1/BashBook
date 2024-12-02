BashBook - README

Overview:
The BashBook project is a basic server-client system developed using bash scripting. It simulates a social media platform where users can create accounts, add friends, post messages to each other's walls, and view their wall. The project includes a server that listens for client requests, performs actions based on those requests, and ensures that operations are synchronised using a locking mechanism. Named pipes are used for communication between the server and the client, and the server operates in an infinite loop to handle multiple requests.

Features:
1. Create a User Account: Users can create a unique account with a given user ID. If the account already exists, an error message is displayed.
2. Add Friends: Users can add other users as friends. An error message is shown if the user or the friend doesn’t exist or they are already friends.
3. Post Messages: Users can post messages to their friends’ walls if they are friends with the recipient.
4. Display Wall: Users can view their wall, which displays messages posted by their friends.
5. Locking Mechanism: A locking mechanism ensures only one client can perform critical operations (like creating a user or posting a message) at a time, preventing race conditions.
6. Graceful Shutdown: The system traps Ctrl+C to automatically delete named pipes when the client or server is terminated.

Project Structure:
- server.sh: The server script that listens for and processes client requests.
- client.sh: The client script sends requests to the server and interacts with the user.
- create.sh: Creates a new user account, including creating directories and files for the user’s wall and friend list.
- add_friend.sh: Adds a new friend to the user’s friend list.
- post_message.sh: Allows users to post messages to their friends' walls.
- display_wall.sh: Displays the user’s wall, showing all messages posted by friends.
- acquire.sh: Acquires a lock for the current client to ensure that no race conditions occur.
- release.sh: Release the provided lock, allowing another client to perform critical actions.

Setup Instructions:
1. Clone the repository to your local machine.
2. Navigate to the project directory:
   cd BashBook
3. Make the scripts executable:
   chmod +x *.sh
4. Start the server in one terminal:
   ./server.sh
5. Start the client in another terminal:
   ./client.sh <user_id>

The specified user id/user refers to the id provided when the client script was first ran.

Commands:
- help: shows the user the provided commands and how to use them.
- create: Creates a new user account with the specified user ID.
- add <friend_id>: Adds a friend to the specified user’s friend list.
- post <receiver_id> <message>: Posts a message on the receiver's wall from the sender [user_id].
- display: Displays the wall of the specified user.
- quit: Exits the client script.

Locking Mechanism:
A locking mechanism prevents multiple clients from performing conflicting operations simultaneously. The lock file (server.lock) ensures that only one client can perform critical actions (like creating a user or posting a message) at a time. When a client requests an operation, it must first acquire the lock. If the lock is already in place, the client will wait until it is released. Once the operation is completed, the client releases the lock so other clients can proceed.

Graceful Shutdown:
When the user presses Ctrl+C or exits the terminal, the script will automatically delete the named pipes to prevent orphaned pipes from lingering. This is handled using the trap command, ensuring the system cleans up resources when terminated.

Common Issues:
1. Server not responding: Ensure the server is running in a separate terminal.
2. Named pipes not deleted: If the client or server crashes, pipes may not be deleted. You can manually delete orphaned pipes using `rm *.pipe`.
3. Locking errors: Ensure all clients properly acquire and release the lock.


