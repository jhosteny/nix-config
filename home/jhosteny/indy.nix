{ inputs, outputs, ... }:
{
  imports = [
    ./global
    ./features/desktop/wireless
    ./features/desktop/hyprland
    ./features/desktop/productivity
    ./features/pass
  ];

  wallpaper = outputs.wallpapers.aenami-wait;
  colorscheme = inputs.nix-colors.colorSchemes.silk-dark;

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      workspace = "1";
      x = 0;
    }
  ];
}
