*This README is in progress*

# My simple desktop nixos + home-manager config with flakes

My NixOS configurations based on Nix flakes. They are deeply integrated with home-manager via my custom module system (accesible via `config.mazurel` or `mazurel`).

## Assumptions

- Single main user (specified by `config.mazurel.username`) + root user.
- Zsh as a shell.
- Alacritty is the main terminal (TODO: Add possibility to choose terminal).

## Module system

This configuration consists of custom module system. 
All custom modules are spocified under `mazurel` attribute.

### Inspecting options

Inspecting custom options avaible in this configuration is quite simple:

1. Start up nix repl and load the flake:
``` bash
nix repl
```
```nix
flake = buitlins.getFlake "<insert path here>"
```

2. See the options by running:
```nix
flake.nixosConfigurations.pc.options.mazurel
```

3. ???
4. Profit !

## Directory structure

- All modules and generic settings are localized in `modules` folder.
- My custom packages, which are avaible via overlay can be found in `packages` folder.
- All settings specific to machines, can be found in `settings` folder.




