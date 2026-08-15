local tab = ...
if not tab then return end

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

local layout = Instance.new("UIListLayout")
layout.Parent = tab
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 15)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createFadedLineContainer()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 110)
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
    addLine(105)
    return container
end

-- 1. Welcome Section
local welcomeCard = Instance.new("Frame")
welcomeCard.Parent = tab
welcomeCard.Size = UDim2.new(1, -20, 0, 60)
welcomeCard.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
welcomeCard.BorderSizePixel = 0
Instance.new("UICorner", welcomeCard).CornerRadius = UDim.new(0, 8)

local gameName = "Blox Fruit"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then gameName = info.Name end
end)

local welcomeText = Instance.new("TextLabel")
welcomeText.Parent = welcomeCard
welcomeText.Size = UDim2.new(1, -20, 1, 0)
welcomeText.Position = UDim2.new(0, 10, 0, 0)
welcomeText.BackgroundTransparency = 1
welcomeText.Font = Enum.Font.GothamBold
welcomeText.TextSize = 13
welcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeText.Text = "👋 Welcome to FishHub! Supported Game: " .. gameName
welcomeText.TextWrapped = true

-- 2. Player Status Section
local statusContainer = createFadedLineContainer()
statusContainer.Parent = tab
statusContainer.Size = UDim2.new(1, -20, 0, 120)

local statusTitle = Instance.new("TextLabel")
statusTitle.Parent = statusContainer
statusTitle.Size = UDim2.new(1, 0, 0, 20)
statusTitle.Position = UDim2.new(0, 0, 0, 10)
statusTitle.BackgroundTransparency = 1
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextSize = 12
statusTitle.TextColor3 = Color3.fromRGB(0, 229, 255)
statusTitle.Text = "PLAYER STATUS"
statusTitle.TextXAlignment = Enum.TextXAlignment.Center

local statusContent = Instance.new("TextLabel")
statusContent.Parent = statusContainer
statusContent.Size = UDim2.new(1, -20, 1, -35)
statusContent.Position = UDim2.new(0, 10, 0, 30)
statusContent.BackgroundTransparency = 1
statusContent.Font = Enum.Font.Code
statusContent.TextSize = 11
statusContent.TextColor3 = Color3.fromRGB(220, 220, 220)
statusContent.TextXAlignment = Enum.TextXAlignment.Center
statusContent.TextYAlignment = Enum.TextYAlignment.Center
statusContent.TextWrapped = true

task.spawn(function()
    while statusContent and statusContent.Parent do
        local leaderstats = player:FindFirstChild("leaderstats")
        local level = leaderstats and leaderstats:FindFirstChild("Level") and leaderstats.Level.Value or 0
        local beli = leaderstats and leaderstats:FindFirstChild("Beli") and leaderstats.Beli.Value or 0.0
        local frag = leaderstats and leaderstats:FindFirstChild("Fragments") and leaderstats.Fragments.Value or 0.0
        local data = player:FindFirstChild("Data")
        local team = data and data:FindFirstChild("Faction") and data.Faction.Value or "Marine"
        
        statusContent.Text = string.format("Level: %.1f | Team: %s\nBeli: %.1f | Fragments: %.1f", tonumber(level) or 0, tostring(team), tonumber(beli) or 0.0, tonumber(frag) or 0.0)
        task.wait(1)
    end
end)

-- 3. Information Section
local infoContainer = createFadedLineContainer()
infoContainer.Parent = tab
infoContainer.Size = UDim2.new(1, -20, 0, 100)

local infoTitle = Instance.new("TextLabel")
infoTitle.Parent = infoContainer
infoTitle.Size = UDim2.new(1, 0, 0, 20)
infoTitle.Position = UDim2.new(0, 0, 0, 10)
infoTitle.BackgroundTransparency = 1
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextSize = 12
infoTitle.TextColor3 = Color3.fromRGB(0, 229, 255)
infoTitle.Text = "USER INFORMATION"
infoTitle.TextXAlignment = Enum.TextXAlignment.Center

local avtImg = Instance.new("ImageLabel")
avtImg.Parent = infoContainer
avtImg.Size = UDim2.new(0, 40, 0, 40)
avtImg.Position = UDim2.new(0, 15, 0, 45)
avtImg.BackgroundTransparency = 1
pcall(function()
    avtImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42)
end)
Instance.new("UICorner", avtImg).CornerRadius = UDim.new(1, 0)

local infoDetails = Instance.new("TextLabel")
infoDetails.Parent = infoContainer
infoDetails.Size = UDim2.new(1, -70, 0, 60)
infoDetails.Position = UDim2.new(0, 65, 0, 35)
infoDetails.BackgroundTransparency = 1
infoDetails.Font = Enum.Font.GothamMedium
infoDetails.TextSize = 11
infoDetails.TextColor3 = Color3.fromRGB(240, 240, 240)
infoDetails.TextXAlignment = Enum.TextXAlignment.Left
infoDetails.Text = string.format("Name: %s\n@Name: @%s\nUserID: %d\nExecutor: %s", player.Name, player.Name, player.UserId, identifyexecutor and identifyexecutor() or "Unknown")
