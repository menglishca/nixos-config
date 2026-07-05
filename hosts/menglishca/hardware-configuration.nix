{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # TODO: Replace with real hardware config from the VPS.
  boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_scsi" "virtio_net" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
