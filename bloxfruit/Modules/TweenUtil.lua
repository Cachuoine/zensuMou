-- [[ Tween Module ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

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
    
    -- Lấy tốc độ từ GameConfig
    local speed = 320
    pcall(function()
        local config = require(game:GetService("ReplicatedStorage").bloxfruit.Config.GameConfig)
        speed = config.TweenSpeed or 320
    end)
    
    local time = distance / speed
    
    local info = TweenInfo.new(time, Enum.EasingStyle.Linear)
    activeTween = TweenService:Create(rootPart, info, {CFrame = CFrame.new(targetPosition)})
    
    activeTween:Play()
    activeTween.Completed:Wait()
end

return TweenModule
