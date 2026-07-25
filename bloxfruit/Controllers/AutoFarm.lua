-- [[ Controllers/AutoFarm.lua ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local vim = game:GetService("VirtualInputManager")

-- Trỏ đường dẫn require tùy theo cách bạn host trên GitHub (hoặc dùng loadstring module con)
-- Ví dụ gọi module tween:
local TweenUtil = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensuMou/bloxfruit/main/UI/Modules/TweenUtil.lua"))()

local AutoFarmController = {}
local isRunning = false
local currentTarget = nil

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

function AutoFarmController.Start()
    if isRunning then return end
    isRunning = true
    
    task.spawn(function()
        print("[AutoFarm Controller]: 🚀 Bắt đầu chạy ngầm...")
        while isRunning do
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    
                    if not currentTarget or not currentTarget:FindFirstChild("HumanoidRootPart") or not currentTarget:FindFirstChild("Humanoid") or currentTarget.Humanoid.Health <= 0 then
                        currentTarget = GetClosestEnemy()
                    end
                    
                    if currentTarget and currentTarget:FindFirstChild("HumanoidRootPart") then
                        TweenUtil.TweenTo(currentTarget.HumanoidRootPart.CFrame)
                        
                        local distance = (character.HumanoidRootPart.Position - currentTarget.HumanoidRootPart.Position).Magnitude
                        if distance < 35 then
                            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            task.wait(0.05)
                            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        end
                    else
                        -- Mặc định bay về Tiki Outpost nếu không thấy quái
                        TweenUtil.TweenTo(CFrame.new(-16516, 50, 1050))
                        currentTarget = nil
                    end
                end
            end)
            task.wait(0.3)
        end
        TweenUtil.Cancel()
        currentTarget = nil
        print("[AutoFarm Controller]: 🛑 Đã dừng.")
    end)
end

function AutoFarmController.Stop()
    isRunning = false
    TweenUtil.Cancel()
end

return AutoFarmController
