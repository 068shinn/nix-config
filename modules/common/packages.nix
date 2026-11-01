{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    htop
    fastfetch
    pfetch
    obsidian
    spotify
    temurin-bin-17
    vscode
  ];
}
