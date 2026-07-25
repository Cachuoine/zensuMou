-- [[ FishHub Loader ]] --
if not game:IsLoaded() then game.Loaded:Wait() end

if getgenv().FishHubLoaded then
    warn("[FishHub]: Đã được khởi chạy trước đó!")
    return
end
getgenv().FishHubLoaded = true

print("[FishHub]: Đang tải hệ thống từ GitHub...")

local CoreGui = game:GetService("CoreGui")

-- Link raw đã cập nhật chuẩn cấu trúc mới
local autoFarmUrl = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/bloxfruit/Controllers/AutoFarm.lua"

local success, response = pcall(function()
    return game:HttpGet(autoFarmUrl)
end)

if not success or not response then
    warn("[FishHub Error]: Không thể tải AutoFarm Controller!")
    return
end

local func, syntaxError = loadstring(response)
if not func then
    warn("[FishHub Error]: Lỗi cú pháp: " .. tostring(syntaxError))
    return
end

local runSuccess, AutoFarm = pcall(func)
if not runSuccess or not AutoFarm then
    warn("[FishHub Error]: Lỗi thực thi AutoFarm: " .. tostring(AutoFarm))
    return
end

-- Tạo giao diện UI
if CoreGui:FindFirstChild("FishHubUI") then 
    CoreGui.FishHubUI:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FishHubUI"

local Btn = Instance.new("TextButton", ScreenGui)
Btn.Size = UDim2.new(0, 220, 0, 50)
Btn.Position = UDim2.new(0.5, -110, 0.2, 0)
Btn.BackgroundColor3 = Color3.fromRGB(25, 27, 38)
Btn.Text = "🐟 FishHub: OFF"
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Font = Enum.Font.SourceSansBold
Btn.TextSize = 16

local Corner = Instance.new("UICorner", Btn)
Corner.CornerRadius = UDim.new(0, 8)

local active = false
Btn.MouseButton1Click:Connect(function()
    active = not active
    if active then
        Btn.BackgroundColor3 = Color3.fromRGB(45, 180, 80)
        Btn.Text = "🐟 FishHub: ON"
        if AutoFarm.Start then AutoFarm.Start() end
    else
        Btn.BackgroundColor3 = Color3.fromRGB(225, 60, 60)
        Btn.Text = "🐟 FishHub: OFF"
        if AutoFarm.Stop then AutoFarm.Stop() end
    end
end)

print("[FishHub]: Khởi chạy thành công!")
