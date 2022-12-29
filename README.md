<div align="center">

# Mine in Abyss Docker Images
</div>

Docker images for our production and development servers. Notably, we use [Keepup](https://github.com/MineInAbyss/Keepup/) to manage plugin versions and Ansible to help with our [server configs](https://github.com/MineInAbyss/server-config).

# Images

## [papermc-dev](https://github.com/MineInAbyss/Docker/pkgs/container/papermc_dev)

A PaperMC image for developers to use on their local machines (see [our wiki](https://wiki.mineinabyss.com/contributing/setup/server-setup/) for a Docker Compose file and more info for setting up locally.)

- Pulls plugins using Keepup. Merges an auto downloaded `mineinabyss.conf` file with a `local.conf` under the `keepup` folder.
- Starts paper using this [image](https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server).
- TODO: No fine control over server version, may need to make our own base image (using alpine linux would reduce filesize too)

```yaml
environment:
  KEEPUP: enabled # whether to run keepup at all
  KEEPUP_PATH: local # the json-path to read plugins from
  PULL_PLUGINS: true # whether to pull an updated mineinabyss.conf file
  PLUGINS_BRANCH: ... # The branch to pull mineinabyss.conf from in the server-config repo
```

## [papermc-prod](https://github.com/MineInAbyss/Docker/pkgs/container/papermc_prod)

A PaperMC image we use in production. Runs config sync with ansible (and eventually plugin sync with Keepup.)

- Pulls and runs an [Ansible](https://ansible.com/) playbook found on [server-config](https://github.com/MineInAbyss/server-config) to copy config files based on the current server. Can choose which branch to pull from by making a `config-branch` file.
  - TODO: Change to use env variables for config branch
- Runs backup using Restic to the remote defined in `secrets-backup`.
  - TODO: Change to use env variables for remote config
- TODO: run keepup to pull plugins based on SERVER_NAME

```yaml
environment:
  USER: container
  HOME: /home/container
  SERVER_NAME: - # The server name (used to choose which configs to pull)
```
