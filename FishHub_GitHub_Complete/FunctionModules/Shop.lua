-- FishHub Function Module: Shop
-- This file is intentionally independent from the main UI.
-- Return a table so FishHub can load/cache it safely.

local Module = {}
Module.Name = "Shop"
Module.Description = "SHOP MODULE ONLINE\n\n• Test Item Shop panel\n• Test purchase controls\n• Test module isolation\n\nThis is a safe UI test module. Replace its Render() body with your own Shop implementation."

function Module.Render(context)
    local label = context and context.ContentLabel
    if label then
        label.Text = Module.Description
    end
    return Module.Description
end

return Module
