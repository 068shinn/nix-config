{ config, pkgs, ... }:
{
  # Template for a second machine with the same shared config.
  imports = [
    ./hardware-configuration.nix
    # ../../modules/optional/sunshine.nix
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
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot = {
    kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    blacklistedKernelModules = [ "nouveau" ];
    kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  };

  system.stateVersion = "26.05";
}
