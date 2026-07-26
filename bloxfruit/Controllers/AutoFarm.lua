-- [[ Controllers/AutoFarm.lua ]] --
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")

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

-- Hàm tự động trang bị vũ khí trong balo
local function EquipWeapon()
    local character = LocalPlayer.Character
    if not character then return end
    
    -- Kiểm tra xem đã cầm tool gì chưa, nếu chưa thì tìm trong Backpack
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and not character:FindFirstChildOfClass("Tool") then
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                humanoid:EquipTool(tool)
                break
            end
        end
    end
end

-- Hàm tìm quái thông minh hơn
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
            -- [TÙY CHỌN]: Nếu bạn muốn lọc đúng tên quái cấp cao, có thể check tên ở đây.
            -- Hiện tại sẽ ưu tiên lọc các con quái ở gần trong tầm nhìn.
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
    print("[AutoFarm Controller]: Đã BẮT ĐẦU Auto Farm chuẩn.")
    
    task.spawn(function()
        while isRunning do
            task.wait(0.1)
            EquipWeapon()
            
            local targetHrp = GetClosestEnemy()
            if targetHrp and TweenUtil and TweenUtil.TweenTo then
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    -- Bay lên cao hơn hẳn (25 đơn vị trục Y) để né đòn của quái
                    local targetCFrame = targetHrp.CFrame + Vector3.new(0, 25, 0)
                    local tween = TweenUtil.TweenTo(targetCFrame, 350)
                    
                    if tween then
                        -- Trong lúc bay đến, thực hiện gửi sự kiện click đánh liên tục xuống dưới
                        task.spawn(function()
                            for i = 1, 8 do
                                if not isRunning then break end
                                vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                task.wait(0.05)
                                vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                                task.wait(0.1)
                            end
                        end)
                        
                        task.wait(tween.TweenInfo.Time)
                    end
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
