-- FishHub Function module: Setting
-- This file intentionally DOES NOT create Search or Back.
-- Those controls already belong to FishHub's Function content page.

return {
    Start = function(self, API)
        if not API then
            return
        end

        API.SetContent([[🛠️ Setting Test]], [[Setting remote module is working.\n\nUI API: READY\nTheme API: READY\nSearch + Back: FishHub handles them.]])

        if API.ShowNotification then
            API.ShowNotification("Setting module loaded successfully.")
        end
    end
}
