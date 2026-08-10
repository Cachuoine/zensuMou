-- FishHub test module: ESP
-- FishHub already provides Search + Back. This module intentionally does not create them.

return {
    Start = function(self, API)
        if API and API.SetContent then
            API.SetContent([[👁️ ESP Test]], [[ESP module loaded successfully.\n\n• Player ESP: OFF\n• Chest ESP: OFF\n• URL loading works\n• Search + Back are provided by FishHub]])
        end

        if API and API.ShowNotification then
            API.ShowNotification("ESP test module loaded.")
        end
    end
}
