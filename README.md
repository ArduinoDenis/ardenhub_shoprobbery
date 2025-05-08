# ArDenHub Shop Robbery

A comprehensive shop and bank robbery system for FiveM ESX servers.

## Features

- Rob various stores and banks across the map
- Configurable police requirements for each robbery type
- Cooldown system to prevent repeated robberies
- Discord webhook integration for logging robbery events
- Police notification system with temporary map blips
- Support for both marker-based and target-based interaction
- Customizable rewards and robbery durations

## Dependencies

- esx-legacy
- ox_lib

## Installation

1. Download the resource
2. Place it in your server's resources directory
3. Add `ensure ardenhub_shoprobbery` to your server.cfg
4. Configure the settings in `config.lua` to your liking
5. Restart your server

## Configuration

The script is highly configurable through the `config.lua` file:

### General Settings

- `UseTarget`: Toggle between target-based or marker-based interaction
- `CooldownTime`: Time in seconds before a location can be robbed again
- `PoliceRequired`: Number of police officers required for each robbery type
- `WebhookURL`: Discord webhook URL for logging events

### Locations

The script comes with pre-configured locations for both shops and banks, but you can easily add, remove, or modify them:

```lua
{
    name = "Store Name",
    coords = vector3(x, y, z),
    heading = 0.0,
    minReward = 3000,
    maxReward = 8000,
    robberyTime = 60, -- Time in seconds
    cooldown = true
}
```

### Blips and Markers

You can customize the appearance of map blips and interaction markers through the config file.

## How It Works

1. Players approach a robbable location and interact with it
2. The system checks if there are enough police officers online
3. If requirements are met, the robbery begins with a progress bar
4. Police officers are notified with a message and a temporary blip on their map
5. Upon successful completion, the player receives dirty money
6. The location enters cooldown and cannot be robbed again for a set period
7. All robbery events are logged to Discord if a webhook is configured

## License

This resource is released under the MIT License.

## Support
For support, contact [**ArDenHub**](https://discord.ardenhub.it) in the discord or open an issue on GitHub.

## Credits

Developed by [**ArduinoDenis.it**](https://arduinodenis.it)