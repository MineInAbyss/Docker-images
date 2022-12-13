<div align="center">

# Docker
</div>

Docker containers for our production and development servers. Notably, we use [Keepup](https://github.com/MineInAbyss/Keepup/) to manage plugin versions and Ansible to help with our [server-configs](https://github.com/MineInAbyss/server-config).

# Images

## [papermc-dev](https://github.com/MineInAbyss/Docker/pkgs/container/papermc_dev)

A PaperMC image for developers to use on their local machines (see [our wiki](https://wiki.mineinabyss.com/contributing/setup/server-setup/).)

```yaml
environment:
  KEEPUP: enabled # whether to run keepup at all
  KEEPUP_PATH: local # the json-path to read plugins from
  PULL_PLUGINS: true # whether to pull an updated mineinabyss.conf file
  PLUGINS_BRANCH: ... # The branch to pull mineinabyss.conf from in the server-configs repo
```

## [papermc-prod](https://github.com/MineInAbyss/Docker/pkgs/container/papermc_prod)

A PaperMC image we use in production. Runs config sync with ansible (and eventually plugin sync with Keepup.)

```yaml
environment:
  USER: container
  HOME: /home/container
```
