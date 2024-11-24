NIX_SSHOPTS="-tt" nixos-rebuild switch \
    --flake .#homelab \
    --target-host lexi@192.168.1.14 \
    --use-remote-sudo