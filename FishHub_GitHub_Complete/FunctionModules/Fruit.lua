-- FishHub Function Module: Fruit
-- This file is intentionally independent from the main UI.
-- Return a table so FishHub can load/cache it safely.

local Module = {}
Module.Name = "Fruit"
Module.Description = "FRUIT MODULE ONLINE\n\n• Test fruit list\n• Test collection state\n• Test storage state\n\nSafe placeholder module."

function Module.Render(context)
    local label = context and context.ContentLabel
    if label then
        label.Text = Module.Description
    end
    return Module.Description
end

return Module
