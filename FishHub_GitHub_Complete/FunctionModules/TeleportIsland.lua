-- FishHub Function module: TeleportIsland
-- This file intentionally DOES NOT create Search or Back.
-- Those controls already belong to FishHub's Function content page.

return {
    Start = function(self, API)
        if not API then
            return
        end

        API.SetContent([[🏝️ Teleport Island Test]], [[Teleport Island remote module is working.\n\nDestination: Test Island\nStatus: READY\nSearch + Back: FishHub handles them.]])

        if API.ShowNotification then
            API.ShowNotification("TeleportIsland module loaded successfully.")
        end
    end
}
