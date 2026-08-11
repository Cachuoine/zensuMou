-- FishHub Function Module: Setting
-- This file is intentionally independent from the main UI.
-- Return a table so FishHub can load/cache it safely.

local Module = {}
Module.Name = "Setting"
Module.Description = "SETTING MODULE ONLINE\n\n• Test hub configuration\n• Test local module settings\n• Test reset/apply state\n\nIndependent from the main FishHub UI."

function Module.Render(context)
    local label = context and context.ContentLabel
    if label then
        label.Text = Module.Description
    end
    return Module.Description
end

return Module
