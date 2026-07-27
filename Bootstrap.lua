-- Bootstrap.lua
local BASE_URL = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub/FishHubCollect/"

local function LoadModule(path)
    local success, result = pcall(function()
        return game:HttpGet(BASE_URL .. path)
    end)
    if success and result then
        local func, err = loadstring(result)
        if func then
            local ok, module = pcall(func)
            if ok then return module end
        end
    end
    return nil
end

-- Tải các thành phần cốt lõi theo đúng cấu trúc
local Config = LoadModule("Core/Config.lua")
local Logger = LoadModule("Core/Logger.lua")
local HWID = LoadModule("Security/HWID.lua")
local KeySystem = LoadModule("Security/KeySystem.lua")

if not Config then
    warn("[FishHub] Không thể tải Config.lua!")
    return
end

print("[FishHub] Hệ thống Bootstrap đã sẵn sàng chạy.")
