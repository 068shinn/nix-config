{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    brave
    gnome-tweaks
    fastfetch
    git
    gnome-randr
    htop
    mangohud
    obsidian
    pfetch
    prismlauncher
    spotify
    temurin-bin-17
    vscode
  ];

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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
}
