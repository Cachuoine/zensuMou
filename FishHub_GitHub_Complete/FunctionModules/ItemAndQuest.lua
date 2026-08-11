-- FishHub Function Module: Item and Quest
-- This file is intentionally independent from the main UI.
-- Return a table so FishHub can load/cache it safely.

local Module = {}
Module.Name = "Item and Quest"
Module.Description = "ITEM & QUEST MODULE ONLINE\n\n• Test quest list\n• Test item list\n• Test progress state\n\nReplace only this file when implementing the feature."

function Module.Render(context)
    local label = context and context.ContentLabel
    if label then
        label.Text = Module.Description
    end
    return Module.Description
end

return Module
