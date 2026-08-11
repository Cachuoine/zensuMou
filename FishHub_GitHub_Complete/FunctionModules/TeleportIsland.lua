-- FishHub Function Module: Teleport Island
-- This file is intentionally independent from the main UI.
-- Return a table so FishHub can load/cache it safely.

local Module = {}
Module.Name = "Teleport Island"
Module.Description = "TELEPORT ISLAND MODULE ONLINE\n\n• Test island selector\n• Test destination state\n• Test teleport button UI hook\n\nThe main UI does not need to change when this module changes."

function Module.Render(context)
    local label = context and context.ContentLabel
    if label then
        label.Text = Module.Description
    end
    return Module.Description
end

return Module
