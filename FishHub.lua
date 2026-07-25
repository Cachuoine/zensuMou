-- [[ FishHub.lua - Loader Tổng ]] --
if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("[FishHub]: Đang khởi động hệ thống Blox Fruits Hub...")

-- Tải và chạy trực tiếp UIController từ GitHub
local success, err = pcall(function()
    local UIModuleCode = game:HttpGet("https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/Controllers/UIController.lua")
    local UIController = loadstring(UIModuleCode)()
    
    -- Tạo và hiển thị Menu lên màn hình
    UIController.CreateMainUI()
end)

if not success then
    warn("[FishHub Lỗi UI]: " .. tostring(err))
else
    print("[FishHub]: Đã tải và hiển thị giao diện thành công!")
end
