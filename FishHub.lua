-- [[ FishHub.lua - Optimized Auto Farm & Anti-Spam Tween ]] --
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
local Workspace = game:GetService("Workspace")
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

-- 2. Hệ thống Tween thông minh (Không bị giật)
local currentTween = nil
local isTweening = false

local function TweenTo(targetCFrame)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    -- Nếu đã ở rất gần mục tiêu thì không tạo tween mới nữa để tránh giật
    if distance < 15 then 
        isTweening = false
        return 
    end

    if not isTweening then
        if currentTween then currentTween:Cancel() end
        
        local speed = 350 -- Tốc độ bay
        local timeTaken = distance / speed
        if timeTaken < 0.1 then timeTaken = 0.1 end

        local tweenInfo = TweenInfo.new(timeTaken, Enum.EasingStyle.Linear)
        currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame + Vector3.new(0, 35, 0)})
        
        isTweening = true
        currentTween:Play()
        
        currentTween.Completed:Connect(function()
            isTweening = false
        end)
    end
end

-- 3. Tìm kiếm quái vật gần nhất trong Sea 3
local function GetClosestEnemy()
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = character.HumanoidRootPart

    local closestEnemy = nil
    local shortestDistance = math.huge

    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            local distance = (hrp.Position - enemy.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestEnemy = enemy
            end
        end
    end

    return closestEnemy
end

-- 4. Vòng lặp Auto Farm tối ưu
local isFarmActive = false

local function StartAutoFarm()
    task.spawn(function()
        print("[AutoFarm]: 🚀 Bắt đầu vòng lặp cày cấp mượt mà!")
        
        while isFarmActive do
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    
                    -- Vì đang ở cấp Max (2800), bỏ qua bước tìm quest, tập trung farm thẳng quái cấp cao tại Sea 3
                    local targetEnemy = GetClosestEnemy()
                    
                    if targetEnemy and targetEnemy:FindFirstChild("HumanoidRootPart") then
                        -- Bay thẳng tới quái gần nhất
                        TweenTo(targetEnemy.HumanoidRootPart.CFrame)
                        
                        -- Giả lập đánh quái liên tục khi đã đến gần
                        local distance = (character.HumanoidRootPart.Position - targetEnemy.HumanoidRootPart.Position).Magnitude
                        if distance < 30 then
                            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            task.wait(0.05)
                            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        end
                    else
                        print("[AutoFarm]: 🔍 Đang tìm kiếm bãi quái trên bản đồ...")
                        -- Bay đến khu vực trung tâm Sea 3 nếu chưa thấy quái quanh đó
                        TweenTo(CFrame.new(-12500, 330, -15000)) 
                    end
                end
            end)
            task.wait(0.3)
        end
        
        if currentTween then currentTween:Cancel() end
        isTweening = false
        print("[AutoFarm]: 🛑 Đã dừng cày cấp.")
    end)
end

-- 5. Xử lý sự kiện bấm nút
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

print("[FishHub]: Khởi chạy hệ thống mượt mà thành công!")
