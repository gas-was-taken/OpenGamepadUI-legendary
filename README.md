# OpenGamepadUI Legendary Plugin

> [!WARNING]  
> This plugin is still being worked on. Use it at your own risk.

This repository contains a plugin for [OpenGamepadUI](https://github.com/ShadowBlip/OpenGamepadUI) that adds support for Epic Games using [legendary](https://github.com/derrod/legendary).  

## Requirements

To make the plugin, you will need `legendary` installed and the dependencies for OpenGamepadUI listed [here](https://opengamepadui.readthedocs.io/en/latest/contributing/development/building_from_source.html#build-requirements).  

## Usage

As of now, a lot of assumptions are made by the plugin and you have to manage yourself the authentification and the installation of games directly using `legendary`.  

In order to make and try this plugin :  

1. Clone this repository

2. Clone the [OpenGamepadUI](https://github.com/ShadowBlip/OpenGamepadUI) repository next to the legendary plugin folder. It should look something like this:

```bash
$ ls
OpenGamepadUI
OpenGamepadUI-legendary
```

4. Run `make build` from the legendary plugin directory to symlink the plugin inside the OpenGamepadUI project directory

5. Run `make build` inside the OpenGamepadUI project directory to build the project

6. Run `make install` inside the legendary plugin directory to install the plugin
