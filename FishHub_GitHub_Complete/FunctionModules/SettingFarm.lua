-- FishHub Function module: SettingFarm
-- This file intentionally DOES NOT create Search or Back.
-- Those controls already belong to FishHub's Function content page.

return {
    Start = function(self, API)
        if not API then
            return
        end

        API.SetContent([[⚙️ Setting Farm Test]], [[Setting Farm remote module is working.\n\nDelay: 0.20s\nWeapon: Melee\nSearch + Back: FishHub handles them.]])

        if API.ShowNotification then
            API.ShowNotification("SettingFarm module loaded successfully.")
        end
    end
}
