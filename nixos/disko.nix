{ disks ? [ "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_500GB_S7EWNJ0W413399V" "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_500GB_S7EWNJ0W413425J" ], ... }: { disko.devices = {
    disk = {
      one = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "boot";
              start = "0";
              end = "1M";
              part-type = "primary";
              flags = [ "bios_grub" ];
            }
            {
              name = "ESP";
              start = "1MiB";
              end = "128MiB";
              fs-type = "fat32";
              bootable = true;
              content = {
                type = "mdraid";
                name = "boot";
              };
            }
            {
              name = "mdadm";
              start = "128MiB";
              end = "100%";
              content = {
                type = "mdraid";
                name = "raid1";
              };
            }
          ];
        };
      };
      two = {
        type = "disk";
        device = builtins.elemAt disks 1;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "boot";
              start = "0";
              end = "1M";
              part-type = "primary";
              flags = [ "bios_grub" ];
            }
            {
              name = "ESP";
              start = "1MiB";
              end = "128MiB";
              fs-type = "fat32";
              bootable = true;
              content = {
                type = "mdraid";
                name = "boot";
              };
            }
            {
              name = "mdadm";
              start = "128MiB";
              end = "100%";
              content = {
                type = "mdraid";
                name = "raid1";
              };
            }
          ];
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
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "primary";
              start = "1MiB";
              end = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            }
          ];
        };
      };
    };
};}


