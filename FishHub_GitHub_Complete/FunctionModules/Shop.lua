-- FishHub Function module: Shop
-- This file intentionally DOES NOT create Search or Back.
-- Those controls already belong to FishHub's Function content page.

return {
    Start = function(self, API)
        if not API then
            return
        end

        API.SetContent([[🛒 Shop Test]], [[Shop remote module is working.\n\nTest UI: READY\nTest action: Shop button\nSearch + Back: FishHub handles them.]])

        if API.ShowNotification then
            API.ShowNotification("Shop module loaded successfully.")
        end
    end
}
