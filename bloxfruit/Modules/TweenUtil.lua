local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local TweenUtil = {}
local currentTween = nil
local isTweening = false

function TweenUtil.TweenTo(targetCFrame)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance < 15 then 
        isTweening = false
        return 
    end

    if not isTweening then
        if currentTween then currentTween:Cancel() end
        local timeTaken = distance / 350
        if timeTaken < 0.1 then timeTaken = 0.1 end

        local tweenInfo = TweenInfo.new(timeTaken, Enum.EasingStyle.Linear)
        currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame + Vector3.new(0, 35, 0)})
        isTweening = true
        currentTween:Play()
        currentTween.Completed:Connect(function()
            isTweening = false
        end)
    end
end

function TweenUtil.Cancel()
    if currentTween then currentTween:Cancel() end
    isTweening = false
end

return TweenUtil
