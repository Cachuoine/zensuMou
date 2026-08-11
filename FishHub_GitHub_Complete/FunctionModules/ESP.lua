-- FishHub Function Module: ESP
-- This file is intentionally independent from the main UI.
-- Return a table so FishHub can load/cache it safely.

local Module = {}
Module.Name = "ESP"
Module.Description = "ESP MODULE ONLINE\n\n• Test player display state\n• Test item display state\n• Test visibility settings\n\nUI-only test content; feature implementation belongs here."

function Module.Render(context)
    local label = context and context.ContentLabel
    if label then
        label.Text = Module.Description
    end
    return Module.Description
end

return Module
