-- FishHub test module: Setting
-- FishHub already provides Search + Back. This module intentionally does not create them.

return {
    Start = function(self, API)
        if API and API.SetContent then
            API.SetContent([[🛠️ Setting Test]], [[Setting module loaded successfully.\n\n• UI: READY\n• Theme API: READY\n• URL loading works\n• Search + Back are provided by FishHub]])
        end

        if API and API.ShowNotification then
            API.ShowNotification("Setting test module loaded.")
        end
    end
}
