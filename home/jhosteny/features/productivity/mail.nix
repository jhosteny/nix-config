{ pkgs, lib, config, ... }:

let
  mbsync = "${config.programs.mbsync.package}/bin/mbsync";
  pass = "${config.programs.password-store.package}/bin/pass";

  common = rec {
    realName = "Joe Hosteny";
    gpg = {
      key = "FF0A DCFB E96E CEFC E6E7 6681 7E89 72E5 3784 A729";
      signByDefault = true;
    };
    signature = {
      showSignature = "append";
      text = ''
        ${realName}

        PGP: ${gpg.key}
      '';
    };
  };
in
{
  home.persistence = {
    "/persist/home/jhosteny".directories = [ "Mail" ];
  };

  accounts.email = {
    maildirBasePath = "Mail";
    accounts = {
      personal = rec {
        primary = true;
        address = "jhosteny@gmail.com";

        folders = {
          inbox = "Inbox";
          drafts = "Drafts";
          sent = "Sent";
          trash = "Trash";
        };
        mbsync = {
          enable = true;
          create = "maildir";
          expunge = "both";
        };
        msmtp = {
          enable = true;
        };
        neomutt = {
          enable = true;
          extraMailboxes = [ "Archive" "Drafts" "Junk" "Sent" "Trash" ];
        };
        imap.host = "imap.gmail.com";
        smtp.host = "smtp.gmail.com";
        userName = address;
        passwordCommand = "${pass} ${smtp.host}/${address}";
      } // common;
      work = rec {
        address = "jhosteny@thoro.ai";

        msmtp.enable = true;
        imap.host = "imap.gmail.com";
        smtp.host = "smtp.gmail.com";
        userName = address;
        passwordCommand = "${pass} ${smtp.host}/${address}";
      } // common;
    };
  };

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;

  systemd.user.services.mbsync = {
    Unit = { Description = "mbsync synchronization"; };
    Service =
      let gpgCmds = import ../cli/gpg-commands.nix { inherit pkgs; };
      in
      {
        Type = "oneshot";
        ExecCondition = ''
          /bin/sh -c "${gpgCmds.isUnlocked}"
        '';
        ExecStart = "${mbsync} -a";
      };
  };
  systemd.user.timers.mbsync = {
    Unit = { Description = "Automatic mbsync synchronization"; };
    Timer = {
      OnBootSec = "30";
      OnUnitActiveSec = "5m";
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };
}
