-- FishHub test module: TeleportIsland
-- FishHub already provides Search + Back. This module intentionally does not create them.

return {
    Start = function(self, API)
        if API and API.SetContent then
            API.SetContent([[🏝️ Teleport Island Test]], [[Teleport Island module loaded successfully.\n\n• Destination: Test Island\n• Status: READY\n• URL loading works\n• Search + Back are provided by FishHub]])
        end

        if API and API.ShowNotification then
            API.ShowNotification("TeleportIsland test module loaded.")
        end
    end
}
