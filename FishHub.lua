-- [[ FishHub.lua - Master Loader ]]

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- 1. Hệ thống xác thực Key / Whitelist (Mở rộng tùy chọn bảo mật)
local function VerifyKey()
    -- Thêm logic kiểm tra key tại đây nếu cần thiết
    return true
end

if not VerifyKey() then
    warn("[FishHub] Xác thực Key thất bại!")
    return
end

-- 2. Định tuyến tựa game thông qua PlaceId
local SupportedGames = {
    [2753915549] = "bloxfruit", -- Blox Fruits Sea 1
    [4442272183] = "bloxfruit", -- Blox Fruits Sea 2
    [7449423635] = "bloxfruit", -- Blox Fruits Sea 3
}

local gameFolder = SupportedGames[game.PlaceId]
if not gameFolder then
    warn("[FishHub] Tựa game này hiện chưa được hỗ trợ!")
    return
end

-- 3. Cấu hình thông tin kho lưu trữ GitHub
local Owner = "zensuMou"
local Repo = "bloxfruit"
local Branch = "main"

local BaseURL = string.format("https://raw.githubusercontent.com/%s/%s/%s/", Owner, Repo, Branch)

-- 4. Hàm nạp file từ xa an toàn toàn cục (Global Loader)
getgenv().ns_load = function(filePath)
    local success, result = pcall(function()
        local rawCode = game:HttpGet(BaseURL .. filePath)
        return loadstring(rawCode)()
    end)
    
    if not success then
        warn("[FishHub Error] Không thể nạp tệp " .. tostring(filePath) .. " | " .. tostring(result))
        return nil
    end
    return result
end

-- 5. Khởi chạy giao diện và logic chính
ns_load("Mainclient.lua")
