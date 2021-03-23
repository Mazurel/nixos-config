# My simple desktop nixos + home-manager config

I am using it on my main machine for programming and everyday useage.

## Channels that I use

```bash
# System config (main nix repos)
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixpkgs 
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

# User (home-manager)
nix-channel --add https://nixos.org/channels/nixos-unstable nixpkgs 
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager 
```

**Note**

Some packages may not be avaible, because they are not yet pushed to nixos-unstable,
if so it is needed to clone nixpkgs repository and use it directly and use command
```bash
sudo nixos-rebuild -I nixpkgs=<paste path to repo here> switch
```
