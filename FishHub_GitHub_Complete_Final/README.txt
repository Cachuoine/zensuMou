# FishHub GitHub Complete

## Main
`FishHub_GitHub_Main_Final.lua`

The main file keeps the existing FishHub UI and all existing non-Function
systems. The Function section is only a loader/registry.

## Function modules
1. Shop.lua
2. SettingFarm.lua
3. Farm.lua
4. ItemAndQuest.lua
5. TeleportIsland.lua
6. Fruit.lua
7. ESP.lua
8. Setting.lua

Each Function module is the complete replacement for that feature: its UI and
functionality belong in that remote file, not in the main FishHub file.

The eight RAW URLs in the main file are the exact URLs supplied by the user.

Function Search/Back remain FishHub navigation. The remote module should not
duplicate them unless intentionally desired.

Function loader notifications were removed so clicking Function does not spam
notifications.
