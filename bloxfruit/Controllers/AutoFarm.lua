-- [[ Controllers/AutoFarm.lua ]] --
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local AutoFarmController = {}
local isRunning = false

-- 1. Tải TweenUtil an toàn
local successTween, TweenUtil = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/bloxfruit/Modules/TweenUtil.lua"))()
end)

-- 2. Tải EnemyConfig an toàn (để lọc quái theo level chuẩn game)
local successConfig, EnemyConfig = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/bloxfruit/Config/EnemyConfig.lua"))()
end)

-- Hàm tìm tên quái phù hợp với level hiện tại của nhân vật dựa vào Config
local function GetTargetEnemyName()
    local myLevel = 1
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    -- Lấy level từ Data hoặc Leaderstats nếu có, mặc định đọc level từ stat game
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local lvlStat = leaderstats:FindFirstChild("Level") or leaderstats:FindFirstChild("LVL")
        if lvlStat then myLevel = lvlStat.Value end
    end

    if successConfig and type(EnemyConfig) == "table" then
        -- Duyệt qua config để tìm con quái có mức level phù hợp nhất với nhân vật
        local bestEnemyName = nil
        local highestReq = -1
        for enemyName, data in pairs(EnemyConfig) do
            local reqLvl = data.Level or data.MinLevel or 1
            if myLevel >= reqLvl and reqLvl > highestReq then
                highestReq = reqLvl
                bestEnemyName = enemyName
            end
        end
        if bestEnemyName then return bestEnemyName end
    end
    
    return nil -- Trả về nil nếu không tìm thấy cấu hình phù hợp
end

-- Hàm tự động trang bị vũ khí và tấn công mượt mà (Không gây đơ máy)
local function AttackTarget()
    local character = LocalPlayer.Character
    if not character then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then
        -- Nếu chưa cầm vũ khí, tìm trong Backpack và equip
        for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if t:IsA("Tool") then
                humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid:EquipTool(t) end
                break
            end
        end
    else
        -- Kích hoạt vũ khí gốc (Không lag, không đơ màn hình)
        pcall(function()
            tool:Activate()
        end)
    end
end

-- Hàm tìm đúng con quái theo yêu cầu
local function GetBestEnemy()
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = character.HumanoidRootPart
    
    local targetName = GetTargetEnemyName()
    local closestEnemy = nil
    local shortestDistance = math.huge
    
    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        
        if enemyHrp and humanoid and humanoid.Health > 0 then
            -- Nếu có tên quái từ Config, ưu tiên tìm đúng tên đó. Nếu không có thì lấy con gần nhất.
            local matchName = true
            if targetName and enemy.Name ~= targetName then
                matchName = false
            end
            
            if matchName then
                local dist = (hrp.Position - enemyHrp.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestEnemy = enemyHrp
                end
            end
        end
    end
    
    -- Fallback: Nếu không tìm thấy đúng tên trong config, lấy tạm con gần nhất để không bị đứng hình
    if not closestEnemy then
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
    end
    
    return closestEnemy
end

function AutoFarmController.Start()
    if isRunning then return end
    isRunning = true
    print("[AutoFarm]: Đã bật chế độ Auto Farm thông minh (Đã tối ưu chống lag).")
    
    task.spawn(function()
        while isRunning do
            task.wait(0.1)
            AttackTarget()
            
            local targetHrp = GetBestEnemy()
            if targetHrp and TweenUtil and TweenUtil.TweenTo then
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    -- Bay lơ lửng ngay trên đầu quái (cách 20 đơn vị để né đòn hoàn toàn)
                    local targetCFrame = targetHrp.CFrame + Vector3.new(0, 20, 0)
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
    print("[AutoFarm]: Đã dừng Auto Farm.")
end

return AutoFarmController
