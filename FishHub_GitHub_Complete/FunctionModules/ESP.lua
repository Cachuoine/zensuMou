-- FishHub Function module: ESP
-- This file intentionally DOES NOT create Search or Back.
-- Those controls already belong to FishHub's Function content page.

return {
    Start = function(self, API)
        if not API then
            return
        end

        API.SetContent([[👁️ ESP Test]], [[ESP remote module is working.\n\nPlayer ESP: OFF\nChest ESP: OFF\nSearch + Back: FishHub handles them.]])

        if API.ShowNotification then
            API.ShowNotification("ESP module loaded successfully.")
        end
    end
}
