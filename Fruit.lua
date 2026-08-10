-- FishHub test module: Fruit
-- FishHub already provides Search + Back. This module intentionally does not create them.

return {
    Start = function(self, API)
        if API and API.SetContent then
            API.SetContent([[🍎 Fruit Test]], [[Fruit module loaded successfully.\n\n• Test Fruit\n• Auto Collect: OFF\n• URL loading works\n• Search + Back are provided by FishHub]])
        end

        if API and API.ShowNotification then
            API.ShowNotification("Fruit test module loaded.")
        end
    end
}
