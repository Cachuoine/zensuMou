-- Core/Network.lua
local HttpService = game:GetService("HttpService")
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub/FishHubCollect/Core/Config.lua"))()

local Network = {}

function Network:Get(endpoint)
    local url = Config.FirebaseUrl .. endpoint .. ".json"
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if success then
        return response
    end
    return nil
end

function Network:Post(endpoint, data)
    local url = Config.FirebaseUrl .. endpoint .. ".json"
    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = url,
            Method = "PATCH",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
    return success
end

return Network
