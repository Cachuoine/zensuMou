-- [[ FishHub.lua - Full Auto Farm Quest & Enemy System ]] --
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

-- 2. Hàm hỗ trợ Tween di chuyển mượt mà
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

-- 3. Kiểm tra nhiệm vụ và tìm quái thông minh
local function HasActiveQuest()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local mainGui = playerGui:FindFirstChild("Main")
        if mainGui then
            local questGui = mainGui:FindFirstChild("Quest")
            if questGui and questGui.Visible then
                return true
            end
        end
    end
    return false
end

local function GetClosestEnemy(enemyName)
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = character.HumanoidRootPart

    local closestEnemy = nil
    local shortestDistance = math.huge

    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            -- Nếu tìm theo tên hoặc quét bất kỳ quái nào gần nhất
            if not enemyName or enemy.Name:find(enemyName) then
                local distance = (hrp.Position - enemy.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestEnemy = enemy
                end
            end
        end
    end

    return closestEnemy
end

-- 4. Vòng lặp Auto Farm thực tế
local isFarmActive = false

local function StartAutoFarm()
    task.spawn(function()
        print("[AutoFarm]: 🚀 Hệ thống cày cấp thông minh đã kích hoạt!")
        
        while isFarmActive do
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    
                    -- Kiểm tra xem đã nhận nhiệm vụ chưa
                    if not HasActiveQuest() then
                        print("[AutoFarm]: 📜 Chưa có nhiệm vụ, đang tìm NPC nhận quest...")
                        -- (Tạm thời di chuyển về trung tâm hoặc vị trí nhận quest Sea 3)
                        TweenTo(CFrame.new(-5000, 100, -3000))
                    else
                        -- Đã có nhiệm vụ -> Tìm quái vật xung quanh để farm
                        local targetEnemy = GetClosestEnemy() -- Quét quái gần nhất
                        
                        if targetEnemy and targetEnemy:FindFirstChild("HumanoidRootPart") then
                            print("[AutoFarm]: ⚔️ Đang bay tới tiêu diệt quái: " .. targetEnemy.Name)
                            TweenTo(targetEnemy.HumanoidRootPart.CFrame)
                            
                            -- Giả lập tấn công liên tục
                            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            task.wait(0.05)
                            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        else
                            print("[AutoFarm]: 🔍 Không tìm thấy quái xung quanh, đang mở rộng phạm vi...")
                            task.wait(1)
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
        
        if currentTween then currentTween:Cancel() end
        print("[AutoFarm]: 🛑 Đã dừng vòng lặp cày cấp.")
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

print("[FishHub]: Khởi chạy hệ thống hoàn tất từ GitHub!")
