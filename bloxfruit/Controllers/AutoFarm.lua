-- [[ Auto Farm Controller ]] --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local ConfigPath = ReplicatedStorage:WaitForChild("bloxfruit"):WaitForChild("Config")
local ModulesPath = ReplicatedStorage:WaitForChild("bloxfruit"):WaitForChild("Modules")

local QuestConfig = require(ConfigPath:WaitForChild("QuestConfig"))
local EnemyConfig = require(ConfigPath:WaitForChild("EnemyConfig"))
local TweenUtil = require(ModulesPath:WaitForChild("TweenUtil"))

local AutoFarm = {}
AutoFarm.Running = false

local function GetCurrentQuest()
    local success, result = pcall(function()
        local playerLevel = LocalPlayer.Data.Level.Value
        for _, quest in ipairs(QuestConfig) do
            if playerLevel >= quest.MinLevel and playerLevel <= quest.MaxLevel then
                return quest
            end
        end
    end)
    return success and result or nil
end

function AutoFarm.Start()
    if AutoFarm.Running then return end
    AutoFarm.Running = true
    
    task.spawn(function()
        print("[AutoFarm]: Đã khởi động hệ thống cày cấp!")
        while AutoFarm.Running do
            pcall(function()
                local currentQuest = GetCurrentQuest()
                if currentQuest then
                    -- 1. Di chuyển đến NPC nhận nhiệm vụ
                    print("Đang bay đến nhận nhiệm vụ: " .. currentQuest.QuestName)
                    TweenUtil.To(currentQuest.NPCSpawn)
                    
                    -- 2. Di chuyển đến bãi quái tương ứng
                    local enemyData = EnemyConfig[currentQuest.MobName]
                    if enemyData then
                        print("Đang bay đến farm quái: " .. currentQuest.MobName)
                        TweenUtil.To(enemyData.SpawnPos)
                    end
                end
            end)
            task.wait(1.5)
        end
    end)
end

function AutoFarm.Stop()
    AutoFarm.Running = false
    TweenUtil.Cancel()
    print("[AutoFarm]: Đã dừng Auto Farm.")
end

return AutoFarm
