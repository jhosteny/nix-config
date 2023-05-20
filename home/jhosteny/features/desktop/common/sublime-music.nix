{ pkgs, lib, ... }: {
  home.packages = [ pkgs.sublime-music ];
  home.persistence = {
    "/persist/home/jhosteny".directories = [ ".config/sublime-music" ];
  };
}
