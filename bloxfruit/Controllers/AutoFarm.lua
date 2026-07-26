-- [[ Controllers/AutoFarm.lua ]] --
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local AutoFarmController = {}
local isRunning = false

-- Tải TweenUtil an toàn
local success, TweenUtil = pcall(function()
    local url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/bloxfruit/Modules/TweenUtil.lua"
    return loadstring(game:HttpGet(url))()
end)

-- Hàm trang bị và tấn công vũ khí mượt mà
local function AttackAction()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local tool = character:FindFirstChildOfClass("Tool")
    
    if not tool then
        -- Nếu chưa cầm vũ khí, lôi từ balo ra
        for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if t:IsA("Tool") and humanoid then
                humanoid:EquipTool(t)
                break
            end
        end
    else
        -- Kích hoạt đòn đánh của vũ khí
        pcall(function()
            tool:Activate()
        end)
    end
end

-- Hàm tìm quái sống gần nhất
local function GetClosestEnemy()
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = character.HumanoidRootPart
    
    local closestEnemy = nil
    local shortestDistance = math.huge
    
    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        
        if enemyHrp and humanoid and humanoid.Health > 0 then
            local dist = (hrp.Position - enemyHrp.Position).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                closestEnemy = enemyHrp
            end
        end
    end
    
    return closestEnemy
end

function AutoFarmController.Start()
    if isRunning then return end
    isRunning = true
    print("[AutoFarm]: Đã BẮT ĐẦU farm thực tế.")
    
    task.spawn(function()
        while isRunning do
            task.wait(0.1)
            AttackAction()
            
            local targetHrp = GetClosestEnemy()
            if targetHrp and TweenUtil and TweenUtil.TweenTo then
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local hrp = character.HumanoidRootPart
                    
                    -- Luôn xoay mặt về phía quái để đánh trúng đích
                    pcall(function()
                        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(targetHrp.Position.X, hrp.Position.Y, targetHrp.Position.Z))
                    end)
                    
                    -- Bay lơ lửng ngay phía trên đầu quái (cách 15 đơn vị để quái không đánh trúng ta)
                    local targetCFrame = targetHrp.CFrame + Vector3.new(0, 15, 0)
                    local tween = TweenUtil.TweenTo(targetCFrame, 350)
                    if tween then
                        task.wait(tween.TweenInfo.Time)
                    end
                end
            end
        end
    end)
end

function AutoFarmController.Stop()
    isRunning = false
    print("[AutoFarm]: Đã DỪNG farm.")
end

return AutoFarmController
