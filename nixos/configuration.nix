# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mnk-portable-server";
  time.timeZone = "Europe/Prague";
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    emacs
    htop
    python3Full
    virtualenv
    kubectl
    postgresql
  ];

  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  systemd.services.loadOnlineConfig = {
    script = ''
      echo hello
      source ${config.system.build.setEnvironment}
      cd /tmp
      rm -rf mnk-server-init
      git clone https://github.com/auto-mat/mnk-server-init.git
      cd mnk-server-init
      exec bash INIT.sh
    '';
    serviceConfig = {
      Restart = "always";
      RestartSec = 3;
    };
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    };

  users.users."root".openssh.authorizedKeys.keys = [
  "sh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqQKJYwnzlx9kFuw+dzsLyqw6qUfd6EQsGHv94RXoV2B4Y/MOI7kQpMau2d7uuE4gifmcCuY8tZM6hy53WwGeZicAkgbG+8d5xlTOCaWlOT7vSIVF0H8seYEW0ZMfIa/RLQjyGjuSvPkLpEeKoMZ2/6Qxa10L4ZuHHlRA+BJrV3MI8Ybmt75EA7eAzBvj1J5nQxZKvOQZsYV+HZ/ex4snNAUOH3Dkc4x2txGJIzRR5qdahMO18uRw4hvwNRO8gUPTQkOomDxLC1PktKVPlxY3ObEMqLi/y5S0HDftASC08N5Pxc21kr1sAW3c1bbtlLpbIoVbavaZCE4jjETkdLaeZ timothy" # content of authorized_keys file
  # note: ssh-copy-id will add user@clientmachine after the public key
  #   # but we can remove the "@clientmachine" part
  ];

  users.users.mtbmap = {
    isNormalUser = true;
    home = "/home/mtbmap";
    description = "MNK user";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
