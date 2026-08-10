-- FishHub Function module: Fruit
-- This file intentionally DOES NOT create Search or Back.
-- Those controls already belong to FishHub's Function content page.

return {
    Start = function(self, API)
        if not API then
            return
        end

        API.SetContent([[🍎 Fruit Test]], [[Fruit remote module is working.\n\nFruit: Test Fruit\nAuto Collect: OFF\nSearch + Back: FishHub handles them.]])

        if API.ShowNotification then
            API.ShowNotification("Fruit module loaded successfully.")
        end
    end
}
