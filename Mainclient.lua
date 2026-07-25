-- [[ Mainclient.lua - Core Client Initializer ]]

if not ns_load then
    warn("[Mainclient Error] Thiếu hàm nạp ns_load từ FishHub!")
    return
end

-- 1. Tải giao diện người dùng (UI Library) từ thư mục bloxfruit/UI/
-- (Bạn có thể thay thế bằng file UI thực tế của bạn, ví dụ: Fluent, Rayfield, hoặc UI tự thiết kế)
local UIModule = ns_load("bloxfruit/UI/MainUI.lua")

if not UIModule then
    warn("[Mainclient Error] Không thể khởi tạo giao diện người dùng!")
    return
end

-- 2. Tải các Controllers và Modules logic cốt lõi từ thư mục bloxfruit/Controllers/
local Controllers = {
    Tween = ns_load("bloxfruit/Controllers/TweenController.lua"),
    AutoFarm = ns_load("bloxfruit/Controllers/AutoFarmController.lua"),
    Combat = ns_load("bloxfruit/Controllers/CombatController.lua"),
}

-- 3. Khởi tạo giao diện và liên kết các tính năng
local function InitializeClient()
    local Window = UIModule:CreateWindow({
        Title = "FishHub | Blox Fruits",
        SubTitle = "Modular Architecture",
        TabWidth = 160
    })

    -- Tạo các Tab chính trên giao diện
    local TabMain = Window:AddTab({ Title = "Auto Farm", Icon = "rbxassetid://0" })
    local TabTeleport = Window:AddTab({ Title = "Teleport", Icon = "rbxassetid://0" })
    local TabSettings = Window:AddTab({ Title = "Settings", Icon = "rbxassetid://0" })

    -- Liên kết logic từ Controllers vào các Tab nếu module tồn tại
    if Controllers.AutoFarm and Controllers.AutoFarm.Init then
        Controllers.AutoFarm.Init(TabMain)
    end

    if Controllers.Tween and Controllers.Tween.Init then
        Controllers.Tween.Init(TabTeleport)
    end
end

InitializeClient()
