<div align="center">

# Mine in Abyss Docker Images
</div>

Docker images for our production and development servers. Notably, we use [Keepup](https://github.com/MineInAbyss/Keepup/) to manage plugin versions and Ansible to help with our [server configs](https://github.com/MineInAbyss/server-config). These are currently tailored to Mine in Abyss, but we hope to expand some config options for other server owners soon.

## [`ghcr.io/mineinabyss/minecraft`](https://github.com/MineInAbyss/Docker/pkgs/container/minecraft)

Java image built on Azul Zulu. On startup it:

- Pulls config files from defined branches using git
- Runs Keepup to automatically download plugins and copy configs where they need to go
- Optionally downloads server jar from a GitHub release as defined by `SERVER_REPO`

See [our docs](https://docs.mineinabyss.com/Docker-images) for more info like a docker compose example and environment variables.