{ disks ? [ "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_500GB_S7EWNJ0W413399V" "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_500GB_S7EWNJ0W413425J" ], ... }: {
  disko.devices = {
    disk = {
      one = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";  # BIOS boot partition type
              priority = 1;
            };
            ESP = {
              size = "127M";  # 128MiB - 1MiB
              type = "EF00";  # EFI System Partition type
              priority = 2;
              content = {
                type = "mdraid";
                name = "boot";
              };
            };
            mdadm = {
              size = "100%";
              priority = 3;
              content = {
                type = "mdraid";
                name = "raid1";
              };
            };
          };
        };
      };
      two = {
        type = "disk";
        device = builtins.elemAt disks 1;
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";  # BIOS boot partition type
              priority = 1;
            };
            ESP = {
              size = "127M";  # 128MiB - 1MiB
              type = "EF00";  # EFI System Partition type
              priority = 2;
              content = {
                type = "mdraid";
                name = "boot";
              };
            };
            mdadm = {
              size = "100%";
              priority = 3;
              content = {
                type = "mdraid";
                name = "raid1";
              };
            };
          };
        };
      };
    };
    mdadm = {
      boot = {
        type = "mdadm";
        level = 1;
        metadata = "1.0";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
        };
      };
      raid1 = {
        type = "mdadm";
        level = 1;
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/";
        };
      };
    };
  };
}

