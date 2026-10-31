{ config, pkgs, ... }:
{
  # Template for a second machine with the same shared config.
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/gaming.nix
    ../../modules/programs.nix
  ];

  networking.hostName = "daughter-pc";

  # Replace this with the actual user's name and desired machine settings.
  users.users.daughter = {
    isNormalUser = true;
    description = "Daughter";
    extraGroups = [ "networkmanager" "wheel" "video" "uinput" ];
    shell = pkgs.zsh;
  };

  services.displayManager.autoLogin.user = "daughter";

  system.stateVersion = "25.11";
}
