<div align="center">

# Mine in Abyss Docker Images
</div>

Docker images for our production and development servers. Notably, we use [Keepup](https://github.com/MineInAbyss/Keepup/) to manage plugin versions and Ansible to help with our [server configs](https://github.com/MineInAbyss/server-config).

# Images

## [minecraft](https://github.com/MineInAbyss/Docker/pkgs/container/papermc_dev)

A PaperMC image based on [itzg/minecraft-server](https://github.com/itzg/docker-minecraft-server). See [our wiki](https://wiki.mineinabyss.com/contributing/setup/server-setup/) for a Docker Compose file and more info for setting up locally.

- Pulls ansible playbook from server config repo and runs it
- Runs keepup based on the plugin versions in server config, with override options
  - Uses `mineinabyss.servers.$SERVER_NAME` as the keepup path

### Volumes
- `/data` server data
- `/server-config` storage for server config repo

### Environment

Default values specified below:

```yaml
environment:
  KEEPUP: true # Runs keepup if set to 'enabled'
  KEEPUP_ALLOW_OVERRIDES: true # Allow overriding plugin versions defined in server-config
  ANSIBLE: true # Tries to run ansible if set to 'enabled
  ANSIBLE_PULL: true # Pulls and runs server-config ansible playbook if set to 'enabled', otherwise tries to run local playbook
  ANSIBLE_PULL_BRANCH: master # server-config branch to pull from
  SERVER_NAME: dev # Name of this server, used in server-config playbook
  UPDATE_DATA_OWNER: false # whether to update the owner of /data to UID:GID
```


## [proxy](https://github.com/MineInAbyss/Docker/pkgs/container/proxy)

Same as `papermc` image, but based on [itzg/bungeecord](https://github.com/itzg/docker-bungeecord)
