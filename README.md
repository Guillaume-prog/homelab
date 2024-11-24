# RPI Homelab

## Setup

https://www.eisfunke.com/posts/2023/nixos-on-raspberry-pi.html


remote build

```
nixos-rebuild switch --flake .#homelab --target-host root@192.168.1.82
```