{ config, pkgs, inputs, lib, ... }:                                  
{                                                                    
  imports = [                                                        
    inputs.nixos-wsl.nixosModules.default                            
    ../../modules/base.nix                                           
    ../../modules/podman.nix                                         
    ../../modules/desktop/niri.nix                                   
    ../../modules/desktop/fonts.nix                                  
    ../../modules/desktop/fcitx5.nix                                 
    ../../modules/services/ssh.nix                                   
    ../../modules/users.nix                                          
  ];                                                                 
                                                                     
  wsl.enable = true;                                                 
  wsl.defaultUser = "reedh";                                         
  wsl.useWindowsDriver = true;  # d3d12 GPU passthrough for WSLg     
                                                                     
  networking.hostName = "wsl";                                       
                                                                     
  local.base.enable = true;                                          
  local.podman.enable = true;                                        
  local.users.enable = true;                                         
  local.desktop.niri.enable = true;                                  
  local.desktop.fonts.enable = true;                                 
  local.desktop.fcitx5.enable = true;                                
  local.services.ssh.enable = true;                                  
                                                                     
  system.stateVersion = "25.11";                                     
} 
