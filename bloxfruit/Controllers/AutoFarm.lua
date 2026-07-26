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

-- 2. Tải EnemyConfig an toàn
local successConfig, EnemyConfig = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/bloxfruit/Config/EnemyConfig.lua"))()
end)

-- Hàm lấy Level hiện tại của người chơi liên tục
local function GetPlayerLevel()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local lvl = leaderstats:FindFirstChild("Level") or leaderstats:FindFirstChild("LVL")
        if lvl then return lvl.Value end
    end
    -- Fallback đọc từ nhân vật hoặc mặc định nếu không tìm thấy
    return 1
end

-- Hàm tìm thông tin quái phù hợp nhất với level hiện tại từ Config
local function GetTargetConfig()
    local myLevel = GetPlayerLevel()
    if successConfig and type(EnemyConfig) == "table" then
        local bestTargetName = nil
        local bestData = nil
        local highestReq = -1
        
        for enemyName, data in pairs(EnemyConfig) do
            -- Kiểm tra các mốc level trong config (ví dụ: Level, MinLevel, RequiredLevel)
            local reqLvl = data.Level or data.MinLevel or data.RequiredLevel or 1
            if myLevel >= reqLvl and reqLvl > highestReq then
                highestReq = reqLvl
                bestTargetName = enemyName
                bestData = data
            end
        end
        return bestTargetName, bestData
    end
    return nil, nil
end

-- Hàm trang bị vũ khí
local function EquipWeapon()
    local character = LocalPlayer.Character
    if not character then return end
    if not character:FindFirstChildOfClass("Tool") then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if humanoid then humanoid:EquipTool(tool) end
                break
            end
        end
    else
        local tool = character:FindFirstChildOfClass("Tool")
        pcall(function() tool:Activate() end)
    end
end

-- Hàm quét quái CHÍNH XÁC theo cấp độ (Không quét bừa quái gần)
local function GetBestEnemyByLevel()
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = character.HumanoidRootPart
    
    local targetName, targetData = GetTargetConfig()
    
    local closestEnemy = nil
    local shortestDistance = math.huge
    
    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        
        if enemyHrp and humanoid and humanoid.Health > 0 then
            local isValid = false
            
            -- Nếu tìm thấy tên quái từ Config, check xem tên trong Workspace có chứa từ khóa đó không
            if targetName and (string.find(enemy.Name, targetName) or (targetData and targetData.FullName and string.find(enemy.Name, targetData.FullName))) then
                isValid = true
            elseif not targetName then
                -- Nếu chưa load được config, mặc định lấy quái ở xa/gần tùy ý nhưng phải có tính toán khoảng cách hợp lý
                isValid = true 
            end
            
            if isValid then
                local dist = (hrp.Position - enemyHrp.Position).Magnitude
                -- Cho phép quét khoảng cách xa (không giới hạn chặt, miễn là đúng loại quái cấp cao)
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
    print("[AutoFarm]: Đã kích hoạt chế độ quét quái theo Level chuẩn xác.")
    
    task.spawn(function()
        while isRunning do
            task.wait(0.1)
            EquipWeapon()
            
            local targetHrp = GetBestEnemyByLevel()
            if targetHrp and TweenUtil and TweenUtil.TweenTo then
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    -- Bay lên đỉnh đầu quái (cách 20 đơn vị để farm an toàn)
                    local targetCFrame = targetHrp.CFrame + Vector3.new(0, 20, 0)
                    local tween = TweenUtil.TweenTo(targetCFrame, 350)
                    if tween then
                        task.wait(tween.TweenInfo.Time)
                    end
                end
            else
                -- Nếu không tìm thấy đúng quái theo level, tạm nghỉ một nhịp để tránh lag loop
                task.wait(1)
            end
        end
    end)
end

function AutoFarmController.Stop()
    isRunning = false
    print("[AutoFarm]: Đã dừng Auto Farm.")
end

return AutoFarmController
