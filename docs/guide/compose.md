# Docker compose

Below is a minimal Docker compose config to get you started. Be sure to read further to see what environment variables are available, some may be very useful for local development.

```yaml
services:
  minecraft-dev:
    container_name: minecraft-dev
    image: "ghcr.io/mineinabyss/minecraft:master"
    ports:
      - "25565:25565" # Minecraft
      - "5005:5005" # JVM debug
      - "8082:8082" # Packy
    env_file: .env
    environment:
      SERVER_REPO: "MineInAbyss/Cartridge"
      SERVER_NAME: "dev-basic"
      MEMORY: "2G"
      # EULA: "true" # Uncomment to accept Minecraft EULA
      PACKY_PUBLIC_ADDRESS: "http://localhost:8082"
      UPDATE_DATA_OWNER: "false"
    volumes:
      - "./server:/data" # Minecraft server data, ex. plugins, worlds, etc.
      - "./configs:/configs" # All server configs will be pulled into here
    tty: true
    stdin_open: true
```

Windows users running in WSL may experience issues if `UPDATE_DATA_OWNER` is set to `true`, do not remove this line.
{ .warning }