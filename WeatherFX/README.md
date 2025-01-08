# WeatherFX Plugin

## Description
WeatherFX Plugin for Ashita v4, that interacts with the game’s internal weather system to dynamically modify weather effects during gameplay. By leveraging the game’s own functions for setting weather, the plugin attempts to set the weather effect as requested by the user. If the request fails (e.g., invalid weather type or unavailable resources), the game will fall back to a default weather setting of Suny or NULL, ensuring the game continues to run smoothly. If NULL the sky will turn black, user will need to select a differnt weather_tag.

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