-- [[ Auto Farm Controller (Full Integration) ]] --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local ConfigPath = ReplicatedStorage:WaitForChild("bloxfruit"):WaitForChild("Config")
local ModulesPath = ReplicatedStorage:WaitForChild("bloxfruit"):WaitForChild("Modules")
local ControllersPath = ReplicatedStorage:WaitForChild("bloxfruit"):WaitForChild("Controllers")

local QuestConfig = require(ConfigPath:WaitForChild("QuestConfig"))
local EnemyConfig = require(ConfigPath:WaitForChild("EnemyConfig"))
local WeaponConfig = require(ConfigPath:WaitForChild("WeaponConfig"))
local GameConfig = require(ConfigPath:WaitForChild("GameConfig"))

local TweenUtil = require(ModulesPath:WaitForChild("TweenUtil"))
local QuestController = require(ControllersPath:WaitForChild("QuestController"))
local CombatController = require(ControllersPath:WaitForChild("CombatController"))
local SkillController = require(ControllersPath:WaitForChild("SkillController"))

local AutoFarm = {}
AutoFarm.Running = false

-- Lấy nhiệm vụ theo level
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
        print("[AutoFarm]: Đã khởi động hệ thống cày cấp toàn diện!")
        while AutoFarm.Running do
            pcall(function()
                local currentQuest = GetCurrentQuest()
                if currentQuest then
                    -- 1. Kiểm tra xem đã nhận nhiệm vụ chưa
                    local hasQuest = QuestController.HasActiveQuest()
                    
                    if not hasQuest then
                        -- Chưa có quest thì bay đến NPC nhận
                        print("[AutoFarm]: Đang bay đến nhận nhiệm vụ: " .. currentQuest.QuestName)
                        TweenUtil.To(currentQuest.NPCSpawn)
                        task.wait(0.5)
                        
                        -- Gửi yêu cầu nhận nhiệm vụ lên server
                        QuestController.AcceptQuest(currentQuest.QuestName, currentQuest.QuestLevel)
                        task.wait(1)
                    else
                        -- Đã có quest, tiến hành bay đến bãi quái
                        local enemyData = EnemyConfig[currentQuest.MobName]
                        if enemyData then
                            -- Trang bị vũ khí mặc định (ví dụ: Melee hoặc Sword từ WeaponConfig)
                            CombatController.EquipWeapon(WeaponConfig.DefaultWeapon or "Combat")
                            
                            -- Bay đến đầu bãi quái (có thể cộng thêm offset trên không để né đòn)
                            local farmPos = enemyData.SpawnPos + Vector3.new(0, 15, 0)
                            TweenUtil.To(farmPos)
                            
                            -- Vòng lặp đánh quái tại chỗ
                            local startTime = tick()
                            while AutoFarm.Running and QuestController.HasActiveQuest() and (tick() - startTime < 30) do
                                CombatController.Attack()
                                SkillController.UseSkills()
                                task.wait(0.2)
                            end
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end

function AutoFarm.Stop()
    AutoFarm.Running = false
    TweenUtil.Cancel()
    print("[AutoFarm]: Đã dừng hoạt động.")
end

return AutoFarm
