# Anime Tower Defense Roblox Expansion Pack

This repository contains a large expansion package for the Roblox tower defense game described in the master prompt. It adds:

- 120 anime-inspired units
- 12 elite bosses
- 10 arena/lobby variants
- a lobby and arena selection system
- a data-first structure for mixing into a Roblox Studio project

## Included files

- `src/AnimeTD/UnitCatalog.lua` — catalog of anime units
- `src/AnimeTD/BossCatalog.lua` — boss definitions and abilities
- `src/AnimeTD/ArenaCatalog.lua` — arena list and lobby metadata
- `src/AnimeTD/LobbySystem.lua` — Roblox lobby builder and arena portal setup

## How to use in Roblox Studio

1. Open Roblox Studio.
2. Create a folder structure like:
   - `ReplicatedStorage/Shared/AnimeTD`
3. Insert the four Lua files into that folder as `ModuleScript` objects.
4. Use the lobby script as a `Script` under `ServerScriptService`.
5. Add arena folders in `Workspace` or build them in your map editor.
6. Use the `UnitCatalog`, `BossCatalog`, and `ArenaCatalog` modules to feed your wave manager, tower factory, and lobby selection logic.

## Notes

This repo is intentionally data-driven so you can plug it into the existing tower defense prototype without rewriting tower logic from scratch.

Recommended next step:

- connect `UnitCatalog` to your tower unlock tree
- attach boss abilities to wave manager transitions
- generate arena portals from `ArenaCatalog`
- use `LobbySystem` for start menu and arena selection
