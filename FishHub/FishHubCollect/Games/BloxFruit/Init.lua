-- Games/BloxFruit/Init.lua
local BASE_URL = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub/FishHubCollect/"
local Config = loadstring(game:HttpGet(BASE_URL .. "Games/BloxFruit/Config.lua"))()
local Features = loadstring(game:HttpGet(BASE_URL .. "Games/BloxFruit/Features.lua"))()

local BloxFruitGame = {}

function BloxFruitGame.Init()
    print("[FishHub] Đang khởi chạy giao diện và tính năng cho: " .. Config.GameName)
    -- Tại đây bạn sẽ liên kết các nút bấm trên UI vào các hàm trong Features.lua
end

return BloxFruitGame
