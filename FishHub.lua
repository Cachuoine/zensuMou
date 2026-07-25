-- [[ FishHub.lua - Full UI & Auto Farm Integration ]] --
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

-- 2. Logic Vòng lặp Auto Farm
local isFarmActive = false

local function StartAutoFarm()
    task.spawn(function()
        print("[AutoFarm]: Đã kích hoạt vòng lặp cày cấp!")
        while isFarmActive do
            pcall(function()
                -- Lấy vị trí nhân vật hiện tại
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    -- Ví dụ test mô phỏng: In ra tọa độ hoặc thực hiện logic bay/đánh quái ở đây
                    -- print("Đang quét tìm nhiệm vụ và quái...")
                    
                    -- Giả lập hành động tấn công nhẹ (click chuột trái)
                    vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.1)
                    vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end)
            task.wait(1) -- Chu kỳ quét mỗi giây
        end
        print("[AutoFarm]: Đã dừng vòng lặp cày cấp.")
    end)
end

-- 3. Xử lý sự kiện bấm nút UI
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

print("[FishHub]: Khởi chạy hệ thống và giao diện thành công từ GitHub!")
