-- URL: https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/creative.lua
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

return function(tabFrame)
    for _, child in ipairs(tabFrame:GetChildren()) do
        child:Destroy()
    end

    local layout = Instance.new("UIListLayout")
    layout.Parent = tabFrame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 250)

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

    -- 1. Roblox Players Section
    locaiRobloxContainer = createFadedLineContainer(tabFrame, 70, 1)
    
    local rbtAvatar = Instance.new("ImageLabel")
    rbtAvatar.Parent = locaiRobloxContainer
    rbtAvatar.Size = UDim2.new(0, 50, 0, 50)
    rbtAvatar.Position = UDim2.new(0, 10, 0.5, -25)
    rbtAvatar.BackgroundTransparency = 1
    pcall(function()
        rbtAvatar.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)

    local rbtText = Instance.new("TextLabel")
    rbtText.Parent = locaiRobloxContainer
    rbtText.Size = UDim2.new(1, -70, 1, 0)
    rbtText.Position = UDim2.new(0, 68, 0, 0)
    rbtText.BackgroundTransparency = 1
    rbtText.Font = Enum.Font.GothamBold
    rbtText.TextSize = 11
    rbtText.TextColor3 = Color3.fromRGB(240, 240, 250)
    rbtText.TextXAlignment = Enum.TextXAlignment.Left
    rbtText.TextYAlignment = Enum.TextYAlignment.Center
    rbtText.Text = "Name: thankhuyenhuy\n@Name: @thankhuyenhuy"

    -- 2. Facebook Players Section
    local fbContainer = createFadedLineContainer(tabFrame, 60, 2)
    
    local fbButton = Instance.new("TextButton")
    fbButton.Parent = fbContainer
    fbButton.Size = UDim2.new(1, -20, 0, 36)
    fbButton.Position = UDim2.new(0.5, 0, 0.5, 0)
    fbButton.AnchorPoint = Vector2.new(0.5, 0.5)
    fbButton.BackgroundColor3 = Color3.fromRGB(24, 119, 242)
    fbButton.BorderSizePixel = 0
    fbButton.Font = Enum.Font.GothamBold
    fbButton.TextSize = 12
    fbButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    fbButton.Text = "Add Facebook Profile"
    Instance.new("UICorner", fbButton).CornerRadius = UDim.new(0, 6)

    fbButton.MouseButton1Click:Connect(function()
        local fbUrl = "https://www.facebook.com/dao.huy.lam.09/"
        pcall(function()
            if setclipboard then
                setclipboard(fbUrl)
            end
        end)
    end)
end
