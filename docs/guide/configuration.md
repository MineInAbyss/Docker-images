# Define config branches

The image currently pulls three repositories, branches can be defined via environment variables or a `mineinabyss.json` file. Configs set to `none` will not be pulled, and private configs will not be pulled if a PAT is not set.

## Private configs

Some configs are private, create a personal access token on GitHub with read access to these repos if you have it and set `GITHUB_PAT` in your environment. 

## Set branches via json

Create a file `server/config/mineinabyss.json` (i.e. next to `paper-global.yml`), below is an example config that includes all available config paths:

```yaml
{
  "configs": {
    "default": "prod",
    "server-config": "prod",
    "server-config-private": "develop",
    "bbmodels": "master"
  }
}
```

Default will be the branch to use if one is not specified, if it isn't set, the environment variable will be used.