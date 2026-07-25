-- [[ Main Client Loader - Blox Fruits Auto Farm ]] --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Đảm bảo game đã load hoàn tất trước khi chạy script
if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("[MainClient]: Đang khởi động hệ thống Auto Farm...")

-- Đường dẫn chính
local RootFolder = ReplicatedStorage:WaitForChild("bloxfruit", 10)
if not RootFolder then
    warn("[MainClient]: Không tìm thấy thư mục bloxfruit trong ReplicatedStorage!")
    return
end

local ConfigPath = RootFolder:WaitForChild("Config")
local ModulesPath = RootFolder:WaitForChild("Modules")
-- (Nếu Controllers nằm trong ReplicatedStorage hoặc ở dạng LocalScript riêng, bạn chỉnh lại path cho phù hợp nhé)

-- Load các Controller chính
-- Giả sử các Controller được đặt trong ReplicatedStorage.bloxfruit.Controllers hoặc bạn require từ chỗ lưu trữ tương ứng
local ControllersPath = RootFolder:FindFirstChild("Controllers")

local success, err = pcall(function()
    -- Load cơ bản các thành phần để test hệ thống
    local GameConfig = require(ConfigPath:WaitForChild("GameConfig"))
    local TweenUtil = require(ModulesPath:WaitForChild("TweenUtil"))
    
    print("[MainClient]: Đã tải xong Config và Modules thành công!")
    print("[MainClient]: Tốc độ bay cấu hình hiện tại: " .. tostring(GameConfig.TweenSpeed))
    
    -- Ví dụ test di chuyển đến vị trí đảo khởi đầu (Pirate Starter / Marine Starter)
    -- TweenUtil.To(Vector3.new(100, 10, 100))
end)

if not success then
    warn("[MainClient]: Lỗi khi khởi động hệ thống: " .. tostring(err))
else
    print("[MainClient]: Hệ thống đã sẵn sàng hoạt động ổn định!")
end
