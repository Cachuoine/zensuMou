-- [[ Modules/TweenUtil.lua ]] --
local TweenUtil = {}
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer

function TweenUtil.TweenTo(targetCFrame, speed)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local timeTween = distance / (speed or 350) -- Tốc độ mặc định
    
    local tweenInfo = TweenInfo.new(timeTween, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- QUAN TRỌNG: Phải có dòng này để loadstring nhận diện được module!
return TweenUtil
