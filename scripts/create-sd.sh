NIXOS_SD_LATEST=https://hydra.nixos.org/job/nixos/trunk-combined/nixos.sd_image.aarch64-linux/latest/download/1
SD_DEVICE=/dev/sda
SSH_PUBKEY=~/.ssh/id_ed25519.pub


nix-shell -p wget zstd
wget -O nixos-sd.img.zst $NIXOS_SD_LATEST
unzstd -d nixos-sd.img.zst
sudo dd if=nixos-sd.img of=$SD_DEVICE bs=4096 conv=fsync status=progress

sudo mv $SSH_PUBKEY PATH_TO_