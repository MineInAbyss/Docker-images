# Environment variables

## Server download

Options for downloading a server jar automatically.

| Variable            | Default       | Description                                                                       |
|---------------------|---------------|-----------------------------------------------------------------------------------|
| `SERVER_REPO`       |               | GitHub repo to download server jar from (uses releases)                           |
| `VERSION`           | latest        | Release tag to pull for server jar.                                               |

## Startup options

Options that affect the Minecraft server during startup.

| Variable            | Default       | Description                                                           |
|---------------------|---------------|-----------------------------------------------------------------------|
| `GID`               | 1000          | Group id to run as                                                    |
| `UID`               | 1000          | User id to run as                                                     |
| `UPDATE_DATA_OWNER` | true          | Whether to set ownership for `/data` and `/config` paths to `UID/PID` |
| `EULA`              | false         | Accepts EULA in server properties if set.                             |
| `MEMORY`            | 2G            | How much memory to allocate.                                          |
| `JVM_REMOTE_DEBUG`  | false         | Enables JVM remote debugger to attach to the server from IDE.         |
| `JVM_XX_OPTS`       |               | JVM options starting with -X (should come first)                      |
| `JVM_OPTS`          | *Aikar flags* | JVM options that come before -jar                                     |
| `EXTRA_ARGS`        |               | Arguments that come after -jar                                        |

## Private assets

Tokens to pull private assets like bbmodels.
We recommend adding the following to your `.env` file rather than compose.


| Variable                   | Description                                                                          |
|----------------------------|--------------------------------------------------------------------------------------|
| `GITHUB_PAT`               | Token used to pull config repos, needed for private configs, bbmodels                |
| `KEEPUP_GITHUB_AUTH_TOKEN` | Auth token for keepup to not get ratelimited/download private plugins if ever needed |
| `PACKY_ACCESS_TOKEN`       | Token for packy to read private repos                                                |
| `PRIVATE_PLUGINS_TOKEN`    | Reposilite token for keepup to download private plugins                              |

Note: we are working on moving everything to just two tokens, some of these are currently used by server-config or Keepup, not the Docker image directly.
{ .info }


## Plugin and config downloads

Options for auto downloading plugins and configs.

| Variable       | Description                                                                   |
|----------------|-------------------------------------------------------------------------------|
| `KEEPUP`       | Whether to run Keepup (download plugins & copy configs to their destinations) |
| `CONFIGS_PULL` | Whether to pull config branches. Disable to work on config repo locally       |
| `SERVER_NAME`  | Defines which configs and plugins will be pulled (see server config repo)     |

### See also:

- [Defining config branches](/guide/configuration) to see how to configure which branches to pull from
- [Keepup](https://github.com/MineInAbyss/Keepup) for other environment variables that can be used with it
- [server-config](https://github.com/MineInAbyss/server-config) for some extra variables that may be read

