# Docker Container Management and Interaction

## Building and Running Docker Containers

### TLDR

Use `docker build` to create an image from a Dockerfile.
Use `docker run` to create and start a new container from an image.
Use `docker start` with `-a` to restart a container and view its output.
Use `docker start` and `docker logs` to restart a container and view its logs separately.

### Building a Docker Image

To build a Docker image from a Dockerfile, use the following command. This will create an image tagged as `cowsayapp` from the Dockerfile in the current directory.

```bash
docker build -t cowsayapp .
```

### Running a Container from an Image

Once the image is built, you can run a container from this image. This command will start a new container instance from the cowsayapp image.

```
docker run --name my-cowsay-container cowsayapp
```

This creates and starts a container named my-cowsay-container. If your container is set up to display output (like using the cowsay command), this output will be shown in the terminal.

### Restarting a Stopped Container

After running a container, it will eventually stop (especially if its main task completes). To restart the same container without creating a new one, you can use the docker start command.

Option 1: Attach to the Container's Output
To restart the container and view its output, use:

```
docker start -a my-cowsay-container
```

This restarts the container and attaches your terminal to its output, allowing you to see the output from the container's main process.

Option 2: Viewing Container's Logs
Alternatively, you can start the container and view its logs:

```docker start my-cowsay-container
docker logs my-cowsay-container
```

This will start the container in the background and docker logs will display the output of the container.

### Running

To start a container and not have its output, or if the container runs and you don't want it to hanf in the shell. Just start it without the `-a` flag.

```
docker start container-name
```

To stop the container if it is running do.

```
docker stop container-name
```

### Additional Notes on Flags

The `-a` or `--attach` flag attaches your terminal to the container's output, useful for viewing output or interacting with the container.

The `-d` or `--detach` flag starts the container in detached mode, where it runs in the background and your terminal is free for other tasks.

# Flags

The `-a` and `-d` flags in Docker commands serve different purposes, and understanding them will clarify how your containers behave when you run them:

## `-a` Flag (Attach)

Flag: `-a` or `--attach`

**Usage**: This flag is used with docker start or docker run commands.

**Function**: It attaches your terminal's standard input, output, and error (STDIN, STDOUT, STDERR) to the container.

**Effect**: When used with docker start, it allows you to see the output of the container in your terminal. For docker run, it can be used to keep the terminal attached to the container even after the command to start the container has been issued.

**Scenario**: You would use -a when you want to interact with the container or view its output directly in your terminal.

## `-d` Flag (Detached)

Flag: `-d` or `--detach`

**Usage**: This flag is used with the `docker run` command.

**Function**: It starts the container in detached mode.

**Effect**: The container runs in the background and does not occupy the current terminal session. You won't see any immediate output from the container in your terminal.

**Scenario**: You would use `-d` when you don’t need to interact with the container immediately and want your terminal free for other tasks.

## Example

**Running a Container in Attached Mode:**

```
docker run -a my-container
```

This command will show you the output of the container in your terminal.

**Running a Container in Detached Mode:**

```
docker run -d my-container
```

This command will start the container in the background, and you'll get the command prompt back immediately for other uses.

In summary, use -a when you want to see or interact with the container's output directly in your terminal, and use -d when you want the container to run in the background without tying up your terminal.

## Seeing the Name of the Created Container

### List All Running Containers

```bash
docker ps
```

This command shows all currently running containers, including their names, IDs, and other details, note if a container is one off and starts and exits after a CMD was run, it won't show as running.

### List All Containers (Running and Stopped)

```
docker ps -a
```

This command lists all containers, whether they are running or have been stopped. You can find the names in the output.

### Inspect a Specific Container

```
docker inspect <container-id>
```

Replace <container-id> with the actual container ID.

## Understanding Container Lifecycle

### Run and Exit

If the Docker container's main process (specified in the CMD or ENTRYPOINT of the Dockerfile) completes, the container stops. For your cowsayapp, this happens immediately after displaying the message.

### Running State

While a container's main process is active, the container is considered "running", and you can interact with it.

## Accessing Container's Filesystem and Running Different Commands

### Interactive Mode

Run the container in interactive mode with a shell. This allows you to execute commands inside the container. For example, to start a Bash shell in an Ubuntu-based container:

Check where your local shell that you want to use is installed, for example if using Git Bash on a windows, do  ```which bash``` here the ouput is ```usr/bin/bash```

```
docker run -it --name my-temp-container cowsayapp usr/bin/bash
```

This opens a Bash shell inside the container. You can run commands, explore the filesystem, or perform other tasks. The `-it` flags are for interactive (`-i`) and terminal (`-t`) mode. Remember run, is for the first time you run the container. This will give you a interactive shell everytime the container starts. So whenever you do `docker start containerappname`

### Use a Temporary Container for Interaction

If you just need temporary access to the container's environment, you can run a one-off new container with an interactive shell using the same image.

```
docker run -it --rm cowsayapp usr/bin/bash
```

Note, you run the image name, not the container. **Essentialy you `run` an image and `start` a container**. This command starts a new container with an interactive Bash shell. The `--rm` flag ensures that the container is removed after you exit the shell, which is useful for temporary or one-off use.

## Execute Commands in a Running Container

If your container is not running and it is set to run a command and stop and you did not run it with a shell like above, this will NOT work. However, if the container is already running and you have a long-running container, you can execute commands in it using `docker exec`. For example:

```
docker exec -it my-running-container usr/bin/bash
```

Replace my-running-container with the name or ID of your running container. This command gives you access to a Bash shell inside the container

## Best Practices

### One-Off Commands

Containers are often used for single, specific tasks (like running a web server, executing a script, etc.). In these cases, the container stops after completing its task.

### Persistent/Interactive Work

For exploration, debugging, or development, running a container in interactive mode with access to a shell is common.

### Long-Running Services

For services (like databases, web servers, etc.), containers are run in the background and managed as needed.

# Docker Usage Guide: Bind Mounts, Volumes, and File Transfers

## Understanding Bind Mounts in Docker

Using a bind mount in Docker allows you to mount a specific file or directory from the host machine into the container. This is particularly useful for development purposes, as it allows you to work on your code in the host environment and see the changes reflected in the container in real-time.

### Using Bind Mounts

1. **Choose the Directory to Mount**:
   - Identify the directory on your host machine that you want to mount into the container.

2. **Run the Container with a Bind Mount**:
   - Use the `docker run` command with the `-v` or `--mount` flag to specify the bind mount.
   - The general format is:

     ```bash
     docker run -v <host_directory>:<container_directory> ...
     ```

     or

     ```bash
     docker run --mount type=bind,source=<host_directory>,target=<container_directory> ...
     ```

   - For Windows Git Bash:

     ```bash
     docker run -v /c/Users/Username/path:/containerPath -it imageName
     ```

   - For Windows WSL:

     ```bash
     docker run -v /mnt/c/Users/Username/path:/containerPath -it imageName
     ```

   - This command mounts the directory from your host machine to the specified path in the container.

3. **Use the `-it` Flag for Interactive Mode**:
   - The `-it` flags are combined to make the Docker container start in interactive mode with a TTY, so you can interact with the container through the command line.
   - `-i` or `--interactive` keeps the standard input open even if not attached.
   - `-t` or `--tty` allocates a pseudo-TTY.
   - Example Command:

     ```bash
     docker run -it -v /path/on/host:/path/in/container imageName
     ```

### Important Considerations for Bind Mounts

- **Overwriting Data**: The directory you mount into the container will overwrite the contents of the directory in the container at the specified path. Ensure that you are not overwriting any important data within the container.
- **Path Differences**: Be aware of the path differences in Git Bash and WSL. Use the appropriate path format for your environment.
- **Permissions**: Ensure that you have the necessary read/write permissions for the directories you are mounting.

## Docker Volumes for Data Persistence

Docker volumes are used to persist data and share it between the host and containers. Volumes are managed by Docker and are more robust than bind mounts.

### Creating and Using Volumes

1. **Create a Docker Volume**:

   ```bash
   docker volume create my_volume

2. **Attach the Volume to a Container**:

    ```
    docker run -v my_volume:/path/in/container -it containerName
    ```

## Transferring Files Between Host and Container

### Copying Files to a Container

```
docker cp /path/on/host/file host_container:/path/in/container
```

### Copying Files from a Container

```
docker cp container:/path/in/container/file /path/on/host
```

## Network Access for File Transfers

If your container has network access and the necessary tools (like curl, wget, or scp), you can download or upload files directly inside the container.

## Security and Persistence

- **Isolation and Security**: Be cautious about what you mount into a container, as it can potentially compromise the security and isolation provided by Docker.
- **Data Persistence**: Data inside a container's filesystem is ephemeral and will be lost when the container is removed unless it is stored in a volume or a bind mount.

## Best Practices

- Use bind mounts for development and real-time code testing.
- Use Docker volumes for data that needs to persist beyond the life of a container.
- Be mindful of the paths and permissions when working with file mounts in Docker.

### Personal Efforts

- This works in windows git bash, to `bind` a file path.

```
docker run -v C:/Users/Victor/hello/:/victor -it ubuntu usr/bin/bash
```

- This works in windows wsl Ubuntu, to `bind` a file path.

```
docker run -v /mnt/c/Users/Victor/hello:/victor -it ubuntu usr/bin/bash
```

It was haning and not working, thus I had to reset WSL with command `wsl --shutdown` executed on powershell. I also closed and reopend the docker service.

### Create and test image on the fly

```docker run -it ubuntu usr/bin/bash```

This will download an ubuntu image and create a container and drop you into the shell of that container. Note the name of the container is random. If you want to name it, add the `--name` flag.
