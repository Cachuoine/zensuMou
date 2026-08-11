-- FishHub Function Module: Setting farm
-- This file is intentionally independent from the main UI.
-- Return a table so FishHub can load/cache it safely.

local Module = {}
Module.Name = "Setting farm"
Module.Description = "SETTING FARM MODULE ONLINE\n\n• Test weapon selector\n• Test farm mode selector\n• Test configuration state\n\nThis module is independent from the FishHub UI shell."

function Module.Render(context)
    local label = context and context.ContentLabel
    if label then
        label.Text = Module.Description
    end
    return Module.Description
end

return Module
