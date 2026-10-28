# Novo

Novo is an Ashita v4 plugin for displaying, building, editing and testing Recast & Detour navmeshes directly in Final Fantasy XI. It now includes collision geometry extraction, OBJ import and export, and an in-game editor for building and modifying navmeshes without constantly switching between the game and external tools.

## Features

- **In-game NavMesh Rendering:** Display Recast & Detour navmeshes directly in FFXI.
- **Collision Geometry Export:** Read collision data from the game and export it as an OBJ file.
- **OBJ Import and Export:** Load and save geometry for use in external modelling and navigation tools.
- **NavMesh Building:** Build navmeshes from the loaded input geometry.
- **NavMesh Loading and Saving:** Load existing `.nav` files and save your builds.
- **Tile Rebuilding:** Rebuild individual tiles when making changes to a tiled navmesh.
- **Off-Mesh Connections:** Create and edit connections between separate areas of the navmesh.
- **Convex Volumes:** Create and edit convex volumes for navmesh building.
- **Pathfinding Tests:** Test paths in-game and investigate navigation issues.
- **Crowd Simulation:** Test crowd movement against the navmesh.
- **Visualisation Tools:** Inspect geometry, navmesh polygons, tiles, connections and other navigation data.
- **Rendering Performance:** Navmesh display performance has been improved to avoid the severe FPS drops experienced previously.

## How to Install

1. Download the repository [here](https://github.com/Xenonsmurf/Ashita-4-Plugins-and-Addons/archive/refs/heads/master.zip).
2. Extract the downloaded archive.
3. Copy `Novo.dll` into your `Ashita4/Plugins` folder.
4. Launch Final Fantasy XI and load the plugin.

## How to Enable In-Game

1. Type `/load Novo` in-game.
2. Enable **Show Overlay** to display the navigation overlay.
3. Use the **NavMesh** controls to load, unload, reload or publish the editor mesh.
4. Use **Read collision mesh from the game** to extract the current zone's collision geometry.
5. Load an existing OBJ file or save the extracted geometry for external editing.
6. Build a navmesh from the input geometry, or load an existing `.nav` file.
7. Use the click tools to inspect the navmesh, test paths, create off-mesh connections, edit convex volumes and rebuild tiles.
8. Save your geometry and navmesh when you are happy with the results.

## Collision Geometry and OBJ Files

Novo can read collision geometry directly from the game and export it to OBJ format. This allows you to inspect and modify the geometry used as input for navmesh generation.

OBJ files are loaded from and saved to:

`Ashita/config/Collision Mesh Files/`

You can edit these files in an external 3D application and then import them back into Novo.

**Please note:** Reading collision data can cause temporary game lag and may occasionally result in a disconnect. If this happens, you should normally be able to log back in and continue playing.

## NavMesh Files

Novo looks for navmesh files in the configured NavMesh folder, normally:

`Ashita/config/NavMesh Files/`

Navmesh files use the `.nav` format. For automatic loading when zoning, name files using the zone ID followed by `.nav`, for example:

- `230.nav`
- `200.nav`

The zone ID filename convention is intended for automatic zone loading. You can also load and save navmesh files manually through the editor.

## Performance and Rendering

- Navmesh rendering has been improved and should no longer cause the severe FPS drops experienced previously.
- Large zones and complex navmeshes can still affect performance, particularly during building and tile rebuilding.
- For the best performance, use `/fps 1` in-game and a compatible D3D proxy. Both commonly used FFXI D3D proxy options have been tested without issues.

## Development and Usage

Novo is intended as a development, visualisation and debugging tool for navmesh creation. It helps identify collision geometry problems, missing polygons, incorrect connections and pathfinding issues.

The plugin provides tools for extracting geometry, building navmeshes, editing navigation data and testing the results in-game.

**Novo will not include movement automation or bot-like functionality.** Its purpose is to help developers create and validate navmeshes.

## Special Thanks

- Atom0s
- Thorny

## Screenshots

![Novo in-game NavMesh editor](https://github.com/Xenonsmurf/Ashita-4-Plugins-and-Addons/blob/master/Novo/test1.png?raw=true)

![Novo in-game NavMesh demo](https://raw.githubusercontent.com/Xenonsmurf/Ashita-4-Plugins-and-Addons/master/Novo/NovoTest.gif)



