-- [[ Controllers/AutoFarm.lua ]] --
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local AutoFarmController = {}
local isRunning = false

-- Tải TweenUtil an toàn từ GitHub
local success, TweenUtil = pcall(function()
    local url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/bloxfruit/Modules/TweenUtil.lua"
    return loadstring(game:HttpGet(url))()
end)

if not success or not TweenUtil then
    warn("[AutoFarm Error]: Không thể tải TweenUtil.lua!")
end

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
    print("[AutoFarm Controller]: Đã BẮT ĐẦU di chuyển farm.")
    
    task.spawn(function()
        while isRunning do
            task.wait(0.1)
            local targetHrp = GetClosestEnemy()
            if targetHrp and TweenUtil and TweenUtil.TweenTo then
                -- Bay lên đỉnh đầu hoặc sát bên cạnh quái (cách 5 đơn vị trục Y)
                local targetCFrame = targetHrp.CFrame + Vector3.new(0, 5, 0)
                local tween = TweenUtil.TweenTo(targetCFrame, 350)
                if tween then
                    task.wait(tween.TweenInfo.Time)
                end
            end
        end
    end)
end

function AutoFarmController.Stop()
    isRunning = false
    print("[AutoFarm Controller]: Đã DỪNG.")
end

return AutoFarmController
