-- FishHub test module: Farm
-- FishHub already provides Search + Back. This module intentionally does not create them.

return {
    Start = function(self, API)
        if API and API.SetContent then
            API.SetContent([[⚔️ Farm Test]], [[Farm module loaded successfully.\n\n• Auto Farm: OFF\n• Target: Test NPC\n• URL loading works\n• Search + Back are provided by FishHub]])
        end

        if API and API.ShowNotification then
            API.ShowNotification("Farm test module loaded.")
        end
    end
}
