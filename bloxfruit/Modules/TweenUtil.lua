-- [[ Tween Module ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local GameConfig = loadstring(game:HttpGet("..."))() -- Hoặc require nếu chạy trong môi trường Studio/Lune, tùy vào bộ load script của bạn.
-- Lưu ý: Nếu bạn dùng hệ thống load file nội bộ, hãy dùng require(script.Parent.Parent.Config.GameConfig)

local TweenModule = {}
local activeTween = nil

function TweenModule.Cancel()
    if activeTween then
        activeTween:Cancel()
        activeTween = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end

function TweenModule.To(targetPosition)
    TweenModule.Cancel()
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character.HumanoidRootPart
    local distance = (rootPart.Position - targetPosition).Magnitude
    
    -- Lấy tốc độ từ GameConfig (mặc định 320 nếu chưa load được)
    local speed = 320
    pcall(function()
        local config = require(game:GetService("ReplicatedStorage").bloxfruit.Config.GameConfig)
        speed = config.TweenSpeed or 320
    end)
    
    local time = distance / speed
    
    local info = TweenInfo.new(time, Enum.EasingStyle.Linear)
    activeTween = TweenService:Create(rootPart, info, {CFrame = CFrame.new(targetPosition)})
    
    activeTween:Play()
    
    -- Tắt va chạm (nếu cần) và cố định nhân vật bay thẳng tới đích
    activeTween.Completed:Wait()
end

return TweenModule
