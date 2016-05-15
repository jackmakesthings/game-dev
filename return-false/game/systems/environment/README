# Environment

An Environment can also be thought of as a stage, level, or section - it represents both a playable area and its inhabitants (including NPCs; not currently including the Player, but this may change). The root, which extends from `_Environment.gd`, is a simple Node2D. It parents the area's `Tilemap` nodes, which in turn parent the Player, NPCs, and any other in-scene objects. It can be looked up on the game root as `Scene`.

## Usage

At any given time, the game tree should only include one Environment. This instance can be created or changed by calling `set_scene(scene_path)` or `change_scene(scene_path)` on the game root. 
*(TODO: document that and link here.)*

The current thinking is that we'll create a new instance of Environment for each discrete area (so we might end up with `Laboratory.tscn`, `Breakroom.tscn`, etc). We may also want to create separate scenes to represent how one area appears/who's in it at different stages of the game, but that's not set in stone yet. It may be easier just to treat the NPCs as dynamic.

## Notes

- The Player, NPCs, walls, and any other objects should all ultimately be placed in the scene's `object_layer` (a TileMap with YSort on)
- NPCs and objects can be instanced or created directly in the scene, or added via script (preferably via the `NPCManager`); the Player is automatically added during scene setup.

## Member variables

- **nav**
    Nodepath 
    Navigation2D instance
- **tiles** 
    Nodepath
    TileMap representing the ground
- **marker**
    Nodepath
    Sprite used to highlight a destination
- **object_layer**
    Nodepath
    TileMap representing walls, parent to any interactive entities in the scene

## Signals

- **walk_to(nav, end, adjust)**
  Emitted in response to a click event
  Recieved by `Player.update_path()`

## Methods

- **_unhandled_input(ev)**

