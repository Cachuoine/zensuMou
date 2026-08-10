-- FishHub Function module: ItemAndQuest
-- This file intentionally DOES NOT create Search or Back.
-- Those controls already belong to FishHub's Function content page.

return {
    Start = function(self, API)
        if not API then
            return
        end

        API.SetContent([[📦 Item & Quest Test]], [[Item & Quest remote module is working.\n\nQuest: Test Quest\nItem: Test Item\nSearch + Back: FishHub handles them.]])

        if API.ShowNotification then
            API.ShowNotification("ItemAndQuest module loaded successfully.")
        end
    end
}
