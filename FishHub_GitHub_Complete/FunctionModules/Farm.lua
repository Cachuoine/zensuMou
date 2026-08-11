-- FishHub Function Module: Farm
-- This file is intentionally independent from the main UI.
-- Return a table so FishHub can load/cache it safely.

local Module = {}
Module.Name = "Farm"
Module.Description = "FARM MODULE ONLINE\n\n• Test farm status\n• Test quest state\n• Test start/stop state\n\nSafe placeholder for testing module loading."

function Module.Render(context)
    local label = context and context.ContentLabel
    if label then
        label.Text = Module.Description
    end
    return Module.Description
end

return Module
