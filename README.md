# NixOS config layout

This repo is organized around four ideas:

- **hosts/**: machine-specific composition, like desktop vs laptop
- **modules/nixos/**: reusable operating system modules
- **modules/home/**: reusable Home Manager modules for user config and dotfiles
- **modules/themes/**: reusable rices/themes, usually consumed through Stylix

## Mental model

A good way to think about this repo is:

- **NixOS** configures the machine
- **Home Manager** configures the user
- **Stylix** applies theme values to supported programs
- **Theme modules** define your visual identity

## Dendritic structure

You mentioned the dendritic pattern.
In practice, that means you start from a shared trunk and branch outward:

- common modules go in                                                                 **modules/**
- machine-specific assembly happens in **hosts/**
- user-specific assembly happens in **users/**
- stylistic variation lives in **modules/themes/**

That keeps your repo easier to reason about than putting everything in one file.

## Typical workflow

- Edit a shared module when behavior should apply to many machines.
- Edit a host file when the change is machine-specific.
- Edit a home module when the change is about your user environment.
- Edit a theme module when the change is about a rice.

## Build commands

Build the configured host:

  sudo nixos-rebuild switch --flake .#testing-vm

Check evaluation without switching:

  nix flake check

## Important note

This migration script creates a **starter structure**.
It does not perfectly infer your intent from every old file.
You should review the generated files and then gradually move more settings into the appropriate modules.
