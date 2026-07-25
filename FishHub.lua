-- [[ FishHub.lua - Full Script với Vòng Lặp Hoạt Động ]] --
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Chống chạy trùng lặp Hub
if getgenv().FishHubLoaded then
    warn("[FishHub]: Hệ thống đã được khởi chạy trước đó rồi!")
    return
end
getgenv().FishHubLoaded = true

print("[FishHub]: Đang khởi động hệ thống Blox Fruits Hub...")

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild("FishHubUI") then
    CoreGui.FishHubUI:Destroy()
end

-- 1. Tạo giao diện ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 260)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 38)
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 45)
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 38, 55)
TitleLabel.Text = "   🐟 FishHub - Blox Fruits Auto Farm"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleLabel

local AutoFarmBtn = Instance.new("TextButton")
AutoFarmBtn.Size = UDim2.new(0.85, 0, 0, 45)
AutoFarmBtn.Position = UDim2.new(0.075, 0, 0.3, 0)
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
AutoFarmBtn.Text = "Auto Farm Level: OFF"
AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmBtn.TextSize = 16
AutoFarmBtn.Font = Enum.Font.SourceSansBold
AutoFarmBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = AutoFarmBtn

-- 2. Vòng lặp Auto Farm có in log trạng thái thực tế
local isFarmActive = false

local function StartAutoFarm()
    task.spawn(function()
        print("[AutoFarm]: 🚀 Hệ thống cày cấp đã bắt đầu chạy ngầm!")
        
        while isFarmActive do
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local hrp = character.HumanoidRootPart
                    
                    -- In log kiểm tra liên tục để xác nhận vòng lặp đang chạy
                    print("[AutoFarm]: Đang quét nhân vật tại tọa độ: ", math.floor(hrp.Position.X), math.floor(hrp.Position.Y), math.floor(hrp.Position.Z))
                    
                    -- Giả lập hành động tấn công nhẹ
                    vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.1)
                    vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end)
            task.wait(1.5) -- Quét mỗi 1.5 giây
        end
        
        print("[AutoFarm]: 🛑 Hệ thống cày cấp đã dừng lại.")
    end)
end

-- 3. Xử lý sự kiện bấm nút
AutoFarmBtn.MouseButton1Click:Connect(function()
    isFarmActive = not isFarmActive
    if isFarmActive then
        AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(45, 180, 80)
        AutoFarmBtn.Text = "Auto Farm Level: ON"
        StartAutoFarm()
    else
        AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        AutoFarmBtn.Text = "Auto Farm Level: OFF"
    end
end)

print("[FishHub]: Khởi chạy giao diện và nạp thành công từ GitHub!")
