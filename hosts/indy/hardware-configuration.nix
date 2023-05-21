{
  imports = [ ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "kvm-intel" ];
    };
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    kernelParams = [
      "i915.enable_psr=0" "log_level=3"
    ];
    extraModprobeConfig = ''
      options i915 force_probe=46a6
    '';
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/cf66c3ad-90e4-4f0d-8fb7-ab7e338e44ea";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/4F2B-8775";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/294f6fdb-2fc9-4438-9efd-87c57a2071c6"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = true;

  nixpkgs.hostPlatform.system = "x86_64-linux";
  powerManagement.cpuFreqGovernor = "powersave";
  hardware.cpu.intel.updateMicrocode = true;
}
