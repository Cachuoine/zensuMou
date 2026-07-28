-- FishHub-Collect.lua (Chạy trên Executor)
local UI_URL = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub/FishHubCollect/UI/Main.lua"

local success, result = pcall(function()
    return game:HttpGet(UI_URL)
end)

if success and result then
    local func, err = loadstring(result)
    if func then
        pcall(func)
    else
        warn("[FishHub] Lỗi dịch mã (loadstring): " .. tostring(err))
    end
else
    warn("[FishHub] Không thể tải URL: " .. tostring(result))
end
