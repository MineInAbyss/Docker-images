# Getting started

## Setup Docker

- Install Docker, follow [:brand-docker: Docker's install guide](https://docs.docker.com/get-docker/).
- Create a server directory and enter it.
- Make a file named `compose.yml` and paste the config from [Docker compose](/guide/compose).
- Server config and plugins will be downloaded automatically using Keepup, if you build any plugins locally, Keepup will use yours instead.
- You can create a `.env` file in the same directory to pass secrets (ex. to download our mob models)

## Run the server

- We recommend devs use [lazydocker](https://github.com/jesseduffield/lazydocker) or [Docker Desktop](https://www.docker.com/products/docker-desktop/) for a GUI to manage containers.
- Run `docker compose up -d` in the directory of your `compose.yml` file to start the server in the background.
- Connect to `localhost` in Minecraft to join the server.
- Op yourself by attaching to your container (`a` in lazydocker) or `docker attach mineinabyss`.