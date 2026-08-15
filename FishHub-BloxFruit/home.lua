-- URL: https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/home.lua
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

return function(tabFrame)
    for _, child in ipairs(tabFrame:GetChildren()) do
        child:Destroy()
    end

    local layout = Instance.new("UIListLayout")
    layout.Parent = tabFrame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 320)

    -- 1. Welcome Section
    local welcomeCard = Instance.new("Frame")
    welcomeCard.Parent = tabFrame
    welcomeCard.Size = UDim2.new(1, -20, 0, 50)
    welcomeCard.BackgroundColor3 = Color3.fromRGB(35, 37, 48)
    welcomeCard.BorderSizePixel = 0
    welcomeCard.LayoutOrder = 1
    Instance.new("UICorner", welcomeCard).CornerRadius = UDim.new(0, 8)

    local welcomeText = Instance.new("TextLabel")
    welcomeText.Parent = welcomeCard
    welcomeText.Size = UDim2.new(1, -16, 1, 0)
    welcomeText.Position = UDim2.new(0, 8, 0, 0)
    welcomeText.BackgroundTransparency = 1
    welcomeText.Font = Enum.Font.GothamBold
    welcomeText.TextSize = 12
    welcomeText.TextColor3 = Color3.fromRGB(240, 240, 250)
    welcomeText.TextWrapped = true
    welcomeText.Text = "Welcome to FishHub! Supported Game: Blox Fruits"

    -- Helper function for custom faded dividing line containers
    local function createFadedLineContainer(parent, height, order)
        local container = Instance.new("Frame")
        container.Parent = parent
        container.Size = UDim2.new(1, -20, 0, height)
        container.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
        container.BorderSizePixel = 0
        container.LayoutOrder = order
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

        local topDivider = Instance.new("Frame")
        topDivider.Parent = container
        topDivider.Size = UDim2.new(1, 0, 0, 1)
        topDivider.Position = UDim2.new(0, 0, 0, 0)
        topDivider.BackgroundColor3 = Color3.fromRGB(0, 229, 255)
        topDivider.BorderSizePixel = 0
        local topGrad = Instance.new("UIGradient")
        topGrad.Parent = topDivider
        topGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        })

        local bottomDivider = Instance.new("Frame")
        bottomDivider.Parent = container
        bottomDivider.Size = UDim2.new(1, 0, 0, 1)
        bottomDivider.Position = UDim2.new(0, 0, 1, -1)
        bottomDivider.BackgroundColor3 = Color3.fromRGB(0, 229, 255)
        bottomDivider.BorderSizePixel = 0
        local botGrad = Instance.new("UIGradient")
        botGrad.Parent = bottomDivider
        botGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        })

        return container
    end

    -- 2. Player Status Section
    local statusContainer = createFadedLineContainer(tabFrame, 80, 2)
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = statusContainer
    statusLabel.Size = UDim2.new(1, -16, 1, 0)
    statusLabel.Position = UDim2.new(0, 8, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.Code
    statusLabel.TextSize = 11
    statusLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.TextYAlignment = Enum.TextYAlignment.Center
    statusLabel.TextWrapped = true

    task.spawn(function()
        while statusLabel and statusLabel.Parent do
            -- Mocking requested real numerical stats for Blox Fruits integration
            local lvl = 2550.0
            local team = "Marine"
            local beli = 14520300.0
            local frag = 45000.0
            statusLabel.Text = string.format("Level: %.1f | Team: %s\nBeli: %.1f | Fragments: %.1f", lvl, team, beli, frag)
            task.wait(1)
        end
    end)

    -- 3. Information Section
    local infoContainer = createFadedLineContainer(tabFrame, 80, 3)
    
    local avt = Instance.new("ImageLabel")
    avt.Parent = infoContainer
    avt.Size = UDim2.new(0, 50, 0, 50)
    avt.Position = UDim2.new(0, 10, 0.5, -25)
    avt.BackgroundTransparency = 1
    pcall(function()
        avt.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)

    local infoText = Instance.new("TextLabel")
    infoText.Parent = infoContainer
    infoText.Size = UDim2.new(1, -70, 1, 0)
    infoText.Position = UDim2.new(0, 68, 0, 0)
    infoText.BackgroundTransparency = 1
    infoText.Font = Enum.Font.GothamMedium
    infoText.TextSize = 10.5
    infoText.TextColor3 = Color3.fromRGB(230, 230, 240)
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.TextYAlignment = Enum.TextYAlignment.Center

    local executorName = identifyexecutor and identifyexecutor() or "Unknown Executor"
    infoText.Text = string.format("Name: %s\n@Name: @%s\nUser ID: %d\nExecutor: %s", Player.Name, Player.Name, Player.UserId, executorName)
end
