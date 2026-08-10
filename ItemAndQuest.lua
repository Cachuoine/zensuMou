-- FishHub test module: ItemAndQuest
-- FishHub already provides Search + Back. This module intentionally does not create them.

return {
    Start = function(self, API)
        if API and API.SetContent then
            API.SetContent([[📦 Item & Quest Test]], [[Item & Quest module loaded successfully.\n\n• Test Quest\n• Test Item\n• URL loading works\n• Search + Back are provided by FishHub]])
        end

        if API and API.ShowNotification then
            API.ShowNotification("ItemAndQuest test module loaded.")
        end
    end
}
