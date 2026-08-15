local tab = ...
if not tab then return end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local layout = Instance.new("UIListLayout")
layout.Parent = tab
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 15)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createFadedLineContainer(height)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, height)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
    
    local function addLine(yPos)
        local line = Instance.new("Frame")
        line.Parent = container
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, 0, yPos)
        line.BackgroundColor3 = Color3.fromRGB(0, 229, 255)
        line.BorderSizePixel = 0
        local grad = Instance.new("UIGradient")
        grad.Parent = line
        grad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
    end
    addLine(5)
    addLine(height - 5)
    return container
end

-- 1. Roblox Players Section
local robloxContainer = createFadedLineContainer(80)
robloxContainer.Parent = tab

local robloxTitle = Instance.new("TextLabel")
robloxTitle.Parent = robloxContainer
robloxTitle.Size = UDim2.new(1, 0, 0, 20)
robloxTitle.Position = UDim2.new(0, 0, 0, 8)
robloxTitle.BackgroundTransparency = 1
robloxTitle.Font = Enum.Font.GothamBold
robloxTitle.TextSize = 11
robloxTitle.TextColor3 = Color3.fromRGB(0, 229, 255)
robloxTitle.Text = "ROBLOX PLAYERS"
robloxTitle.TextXAlignment = Enum.TextXAlignment.Center

local avtImg = Instance.new("ImageLabel")
avtImg.Parent = robloxContainer
avtImg.Size = UDim2.new(0, 40, 0, 40)
avtImg.Position = UDim2.new(0, 15, 0, 30)
avtImg.BackgroundTransparency = 1
pcall(function()
    avtImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42)
end)
Instance.new("UICorner", avtImg).CornerRadius = UDim.new(1, 0)

local robloxInfo = Instance.new("TextLabel")
robloxInfo.Parent = robloxContainer
robloxInfo.Size = UDim2.new(1, -70, 0, 40)
robloxInfo.Position = UDim2.new(0, 65, 0, 30)
robloxInfo.BackgroundTransparency = 1
robloxInfo.Font = Enum.Font.GothamMedium
robloxInfo.TextSize = 11
robloxInfo.TextColor3 = Color3.fromRGB(240, 240, 240)
robloxInfo.TextXAlignment = Enum.TextXAlignment.Left
robloxInfo.Text = string.format("thanhluyenhuy\nName: %s\n@thanhluyenhuy", player.Name)

-- 2. Facebook Players Section
local fbContainer = createFadedLineContainer(70)
fbContainer.Parent = tab

local fbTitle = Instance.new("TextLabel")
fbTitle.Parent = fbContainer
fbTitle.Size = UDim2.new(1, 0, 0, 20)
fbTitle.Position = UDim2.new(0, 0, 0, 8)
fbTitle.BackgroundTransparency = 1
fbTitle.Font = Enum.Font.GothamBold
fbTitle.TextSize = 11
fbTitle.TextColor3 = Color3.fromRGB(0, 229, 255)
fbTitle.Text = "FACEBOOK PLAYERS"
fbTitle.TextXAlignment = Enum.TextXAlignment.Center

local addBtn = Instance.new("TextButton")
addBtn.Parent = fbContainer
addBtn.Size = UDim2.new(1, -20, 0, 30)
addBtn.Position = UDim2.new(0, 10, 0, 32)
addBtn.BackgroundColor3 = Color3.fromRGB(24, 119, 242)
addBtn.BorderSizePixel = 0
addBtn.Font = Enum.Font.GothamBold
addBtn.TextSize = 12
addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addBtn.Text = "Add Facebook"
Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0, 6)

addBtn.MouseButton1Click:Connect(function()
    local url = "https://www.facebook.com/dao.huy.lam.09/"
    pcall(function()
        if setclipboard then
            setclipboard(url)
        end
    end)
    -- Nếu hỗ trợ mở trình duyệt
    pcall(function()
        if syn and syn.request then
            syn.request({Url = "http://127.0.0.1:6463/rpc?v=1", Method = "POST"}) -- fallback hoặc mở link
        end
    end)
end)
