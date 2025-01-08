# WeatherFX Plugin

## Description
The WeatherFX Plugin for Ashita v4 interacts with the game’s weather system to change weather effects during gameplay. It uses the game’s built-in functions to set the weather based on the user’s request. If the request fails (e.g., invalid weather or missing resources), it will default to Sunny or NULL. If the weather is set to NULL, the sky will turn black, and the user will need to choose a different weather tag.

## /load WeatherFX
This loads the plug-in.

## /unload WeatherFX
This unloads the plug-in.

## Examples
#### Change Weather to Rain:
To attempt to change the weather to Rain, simply select "rain" from the drop down menu.

#### Fallback to Suny:
If the weather setting fails (e.g., requested weather not supported, resource not found) game will attempt to fallback to "suny".

#### NULL Weather Handling:
In case the weather is set to NULL (due to an invalid or missing weather effect), the sky will turn black, user to select a different valid weather tag.

![](https://github.com/Xenonsmurf/Ashita-4-Plugins-and-Addons/blob/master/WeatherFX/examples/WeatherFx.gif)
