-- FishHub test module: SettingFarm
-- FishHub already provides Search + Back. This module intentionally does not create them.

return {
    Start = function(self, API)
        if API and API.SetContent then
            API.SetContent([[⚙️ Setting Farm Test]], [[Setting Farm module loaded successfully.\n\n• Delay: 0.20s\n• Weapon: Melee\n• URL loading works\n• Search + Back are provided by FishHub]])
        end

        if API and API.ShowNotification then
            API.ShowNotification("SettingFarm test module loaded.")
        end
    end
}
