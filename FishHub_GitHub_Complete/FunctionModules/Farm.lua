-- FishHub Function module: Farm
-- This file intentionally DOES NOT create Search or Back.
-- Those controls already belong to FishHub's Function content page.

return {
    Start = function(self, API)
        if not API then
            return
        end

        API.SetContent([[⚔️ Farm Test]], [[Farm remote module is working.\n\nAuto Farm: OFF\nTarget: Test NPC\nSearch + Back: FishHub handles them.]])

        if API.ShowNotification then
            API.ShowNotification("Farm module loaded successfully.")
        end
    end
}
