Updating the config:
--------------------

```
cd /etc/nixos/mnk-server-init
sudo git pull
sudo nixos-rebuild --switch
```

First time setup:
-----------------
(Inspired by [disko manual](https://github.com/nix-community/disko/blob/master/docs/quickstart.md))

Format disks:

```
sudo nix  --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode zap_create_mount ./disko.nix --arg disks '[ "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_500GB_S7EWNJ0W413399V" "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_500GB_S7EWNJ0W413425J" ]'
```

Start config:

```
sudo nixos-generate-config --no-filesystems --root /mnt
```

Copy disko config to configurations dir:

```
cd /mnt/etc/nixos/
sudo git clone git@github.com:auto-mat/mnk-server-init.git
sudo rm configuration.nix
sudo ln -s mnk-server-init/nixos/configuration.nix ./
```

Run the install:

```
sudo nixos-install
```
