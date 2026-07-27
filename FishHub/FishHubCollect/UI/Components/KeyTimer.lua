-- UI/Components/KeyTimer.lua
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub/FishHubCollect/UI/Theme.lua"))()

local KeyTimer = {}

function KeyTimer.new(parent, expirationTime)
    local TimerFrame = Instance.new("Frame")
    TimerFrame.Size = UDim2.new(1, 0, 0, 40)
    TimerFrame.BackgroundColor3 = Theme.Container
    TimerFrame.BorderSizePixel = 0
    TimerFrame.Parent = parent
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = TimerFrame
    
    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Size = UDim2.new(1, -20, 1, 0)
    TimerLabel.Position = UDim2.new(0, 10, 0, 0)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Font = Enum.Font.GothamMedium
    TimerLabel.TextColor3 = Theme.TextWhite
    TimerLabel.TextSize = 13
    TimerLabel.TextXAlignment = Enum.TextXAlignment.Left
    TimerLabel.Parent = TimerFrame
    
    -- Vòng lặp đếm ngược thời gian thực
    task.spawn(function()
        while task.wait(1) do
            local timeLeft = expirationTime - os.time()
            if timeLeft > 0 then
                local hours = math.floor(timeLeft / 3600)
                local minutes = math.floor((timeLeft % 3600) / 60)
                local seconds = timeLeft % 60
                TimerLabel.Text = string.format("Thời hạn Key: %02d:%02d:%02d", hours, minutes, seconds)
            else
                TimerLabel.Text = "Key đã hết hạn! Vui lòng lấy lại key."
                TimerLabel.TextColor3 = Theme.Error
                break
            end
        end
    end)
    
    return TimerFrame
end

return KeyTimer
