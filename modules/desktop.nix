#desktop.nix
#For now just packages I only want on my desktop

{ pkgs, lib, config, ... }:

{
  options = {
    custom.desktopp.enable = 
      lib.mkEnableOption "desktop packages";
  };
  
  custom.desktopp.enable =
    lib.mkDefault false;

  config = lib.mkIf config.custom.desktopp.enable {
 
  environtment.systemPackages = with pkgs; [
    whipper
   ]; 
  };
}
