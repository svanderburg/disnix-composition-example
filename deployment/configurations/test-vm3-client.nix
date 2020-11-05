{pkgs, lib, ...}:

{
  services = {
    disnix = {
      enable = true;
    };

    openssh = {
      enable = true;
    };

    xserver = {
      enable = true;

      displayManager = {
        autoLogin = {
          enable = true;
          user = "root";
        };
        defaultSession = "none+icewm";
      };

      windowManager.icewm.enable = true;
    };
  };

  # lightdm by default doesn't allow auto login for root
  # Override it here.
  security.pam.services.lightdm-autologin.text = lib.mkForce ''
    auth     requisite pam_nologin.so
    auth     required  pam_succeed_if.so quiet
    auth     required  pam_permit.so

    account  include   lightdm

    password include   lightdm

    session  include   lightdm
  '';

  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.subversion
      pkgs.lynx
      pkgs.firefox
    ];
  };
}
