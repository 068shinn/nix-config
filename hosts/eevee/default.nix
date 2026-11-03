{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/core.nix
    ../../modules/common/networking.nix
    ../../modules/common/packages.nix
    ../../modules/common/shell.nix
    ../../modules/common/users.nix
    ../../modules/desktops/kde.nix
    ../../modules/gaming.nix
    ../../modules/programs.nix
  ];

  networking.hostName = "eevee";

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  users.users.ava = {
    isNormalUser = true;
    description = "Ava Shinn";
    extraGroups = [ "networkmanager" "wheel" "video" "uinput" ];
    shell = pkgs.zsh;
  };

  services.displayManager.autoLogin.user = "ava";

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false; # GTX 980 Ti (Maxwell) does not support open kernel modules
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  system.stateVersion = "26.05";
}