# Pull base image
# Purpose: Dockerfile for building a docker image for the project
FROM ubuntu:20.04

# Install cowsay with flags -y -q to avoid interactive mode and suppress output
# Purpose: Install cowsay package
RUN apt-get update && apt-get install -y -q cowsay

# Create a symbolic link for cowsay
# Purpose: Create a symbolic link for cowsay since it is installed in /usr/games and not in /usr/bin where the PATH variable is pointing to which is the default location for executable files
# RUN ln -s /usr/games/cowsay /usr/bin/cowsay

# Add /usr/games to the PATH environment variable
ENV PATH="${PATH}:/usr/games"

# Copy the current directory contents into the container at /app
# Purpose: Copy the current directory contents into the container 
COPY . ./

# Purpose: We are setting environment variables
ENV PORT=8080

# Run the command inside your image filesystem
# Purpose: Run the command inside your image filesystem to say hello world
# CMD ["/bin/bash", "/cowsay.sh"]

# If I run this CMD when I create a container, it will just wait and not execute, thus the container will be running but not doing anything until I exec into it and run the command
# CMD ["/bin/bash", "-c", "while true; do sleep 10; done"]
# The -i flag forces Bash to start in interactive mode, but this might not be sufficient if the container is not attached to a terminal.

# CMD ["/bin/bash", "-i"]

# A temporary solution for debugging could be to use a sleep command in the Dockerfile. This is not recommended for production but can be useful in a development environment:
CMD ["sleep", "infinity"]

