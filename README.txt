FishHub Function Test Pack

The main FishHub UI already has Search + Back inside each Function sub-page.
Therefore the eight remote test modules do NOT create another Search or Back.

Put each Lua file on GitHub, copy its RAW URL, and paste it into the matching
FeatureScripts entry in FishHub_Final_Complete.lua.

Remote module contract:
return {
    Start = function(self, API)
        API.SetContent("Title", "Content")
        API.ShowNotification("Loaded")
    end
}
