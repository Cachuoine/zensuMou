-- Bootstrap.lua
local BASE_URL = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub/FishHubCollect/"

-- Hàm tải module an toàn từ GitHub
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

-- 1. Tải các cấu hình và công cụ lõi
local Config = LoadModule("Core/Config.lua")
local HWID = LoadModule("Security/HWID.lua")
local KeySystem = LoadModule("Security/KeySystem.lua")
local MainUI = LoadModule("UI/Main.lua")

if not Config or not MainUI then
    warn("[FishHub] Lỗi nghiêm trọng: Không thể tải các module cốt lõi!")
    return
end

-- 2. Kiểm tra trạng thái Key hoặc hiển thị bảng nhập Key
-- (Ở đây chúng ta gọi thẳng giao diện KeySystem để người dùng xác thực)
if MainUI.RenderKeyUI then
    MainUI.RenderKeyUI()
end

-- 3. Nhận diện Game và tự động load tính năng tương ứng sau khi vượt Key thành công
local PlaceId = game.PlaceId
local BloxFruitPlaceIds = {2753915549, 4442272183, 7449423635}

local SelectedGame
if table.find(BloxFruitPlaceIds, PlaceId) then
    SelectedGame = LoadModule("Games/BloxFruit/Init.lua")
else
    SelectedGame = LoadModule("Games/Default.lua")
end

if SelectedGame and SelectedGame.Init then
    -- Lưu ý: Bạn có thể gọi SelectedGame.Init() sau khi người dùng nhập Key thành công trong UI Main
    -- Hiện tại hệ thống đã sẵn sàng kết nối toàn bộ cấu trúc!
end
