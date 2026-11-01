{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
