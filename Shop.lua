-- FishHub test module: Shop
-- FishHub already provides Search + Back. This module intentionally does not create them.

return {
    Start = function(self, API)
        if API and API.SetContent then
            API.SetContent([[🛒 Shop Test]], [[Shop module loaded successfully.\n\n• Test Shop Card\n• URL loading works\n• Search + Back are provided by FishHub]])
        end

        if API and API.ShowNotification then
            API.ShowNotification("Shop test module loaded.")
        end
    end
}
