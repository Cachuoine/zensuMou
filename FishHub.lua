-- [[ FishHub.lua - Full Script + Tween Movement ]] --
if not game:IsLoaded() then
    game.Loaded:Wait()
end

if getgenv().FishHubLoaded then
    warn("[FishHub]: Hệ thống đã được khởi chạy trước đó rồi!")
    return
end
getgenv().FishHubLoaded = true

print("[FishHub]: Đang khởi động hệ thống Blox Fruits Hub...")

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

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

-- 2. Hàm hỗ trợ Tween (Bay đến mục tiêu)
local currentTween = nil
local function TweenTo(targetCFrame)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart

    if currentTween then 
        currentTween:Cancel() 
    end

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local speed = 350 -- Tốc độ bay (studs/s)
    local timeTaken = distance / speed
    if timeTaken < 0.1 then timeTaken = 0.1 end

    local tweenInfo = TweenInfo.new(timeTaken, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame + Vector3.new(0, 40, 0)})
    currentTween:Play()
end

-- 3. Vòng lặp Auto Farm thực hiện bay
local isFarmActive = false

local function StartAutoFarm()
    task.spawn(function()
        print("[AutoFarm]: 🚀 Bắt đầu vòng lặp bay đến mục tiêu!")
        
        while isFarmActive do
            local success, err = pcall(function()
                -- Tọa độ mẫu trên bản đồ (Ví dụ: Đảo trung tâm Sea 1/2/3 tùy vị trí)
                local targetPos = CFrame.new(1000, 150, -1000) 
                
                print("[AutoFarm]: ✈️ Đang bay tới tọa độ chỉ định...")
                TweenTo(targetPos)
            end)
            
            if not success then
                warn("[AutoFarm Lỗi]: " .. tostring(err))
            end
            
            task.wait(4) -- Đợi 4 giây thực hiện tween lại một lần
        end
        
        if currentTween then currentTween:Cancel() end
        print("[AutoFarm]: 🛑 Đã dừng vòng lặp bay.")
    end)
end

-- 4. Xử lý sự kiện bấm nút
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

print("[FishHub]: Khởi chạy hệ thống thành công!")
