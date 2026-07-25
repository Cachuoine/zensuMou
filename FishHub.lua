-- [[ FishHub.lua - Tiki Outpost Target Locking Farm ]] --
if not game:IsLoaded() then
    game.Loaded:Wait()
end

if getgenv().FishHubLoaded then
    warn("[FishHub]: Hệ thống đã được khởi chạy trước đó rồi!")
    return
end
getgenv().FishHubLoaded = true

print("[FishHub]: Đang khởi động hệ thống Tiki Outpost Farm với Target Lock...")

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
TitleLabel.Text = "   🐟 FishHub - Tiki Outpost Auto Farm"
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
AutoFarmBtn.Text = "Auto Farm Tiki: OFF"
AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmBtn.TextSize = 16
AutoFarmBtn.Font = Enum.Font.SourceSansBold
AutoFarmBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = AutoFarmBtn

-- 2. Hệ thống Tween mượt mà
local currentTween = nil
local isTweening = false

local function TweenTo(targetCFrame)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance < 15 then 
        isTweening = false
        return 
    end

    if not isTweening then
        if currentTween then currentTween:Cancel() end
        
        local speed = 350
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

-- 3. Tìm kiếm quái vật gần nhất
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

-- 4. Vòng lặp Auto Farm có khóa mục tiêu (Target Locking)
local isFarmActive = false
local currentTarget = nil

local function StartAutoFarm()
    task.spawn(function()
        print("[AutoFarm]: 🚀 Bắt đầu vòng lặp khóa mục tiêu Tiki Outpost!")
        
        while isFarmActive do
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    
                    -- Kiểm tra xem mục tiêu hiện tại còn sống và hợp lệ không
                    if not currentTarget or not currentTarget:FindFirstChild("HumanoidRootPart") or not currentTarget:FindFirstChild("Humanoid") or currentTarget.Humanoid.Health <= 0 then
                        currentTarget = GetClosestEnemy() -- Chỉ tìm con mới khi con cũ đã chết hoặc mất tích
                    end
                    
                    if currentTarget and currentTarget:FindFirstChild("HumanoidRootPart") then
                        print("[AutoFarm]: ⚔️ Đang tập trung tiêu diệt: " .. currentTarget.Name)
                        TweenTo(currentTarget.HumanoidRootPart.CFrame)
                        
                        local distance = (character.HumanoidRootPart.Position - currentTarget.HumanoidRootPart.Position).Magnitude
                        if distance < 35 then
                            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            task.wait(0.05)
                            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        end
                    else
                        print("[AutoFarm]: 🏝️ Đang bay về đảo Tiki Outpost tìm quái...")
                        TweenTo(CFrame.new(-16516, 50, 1050)) 
                        currentTarget = nil
                    end
                end
            end)
            task.wait(0.3)
        end
        
        if currentTween then currentTween:Cancel() end
        isTweening = false
        currentTarget = nil
        print("[AutoFarm]: 🛑 Đã dừng cày cấp.")
    end)
end

-- 5. Xử lý sự kiện bấm nút
AutoFarmBtn.MouseButton1Click:Connect(function()
    isFarmActive = not isFarmActive
    if isFarmActive then
        AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(45, 180, 80)
        AutoFarmBtn.Text = "Auto Farm Tiki: ON"
        StartAutoFarm()
    else
        AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        AutoFarmBtn.Text = "Auto Farm Tiki: OFF"
    end
end)

print("[FishHub]: Khởi chạy hệ thống khóa mục tiêu thành công!")
