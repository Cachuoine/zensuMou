return function(ctx)
    local parent = ctx.Parent
    local theme = ctx.ThemeColor or Color3.fromRGB(0, 229, 255)
    local TweenService = ctx.TweenService or game:GetService("TweenService")
    local Players = ctx.Players or game:GetService("Players")
    local Player = ctx.Player or Players.LocalPlayer
    local MarketplaceService = ctx.MarketplaceService or game:GetService("MarketplaceService")
    local ShowNotification = ctx.ShowNotification
    local function corner(obj, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius)
        c.Parent = obj
        return c
    end
    local function stroke(obj, color, thickness, transparency)
        local s = Instance.new("UIStroke")
        s.Color = color or theme
        s.Thickness = thickness or 1
        s.Transparency = transparency or 0
        s.Parent = obj
        return s
    end
    local function label(parentObject, text, size, position, font, textSize, color, align)
        local l = Instance.new("TextLabel")
        l.Parent = parentObject
        l.Size = size
        l.Position = position
        l.BackgroundTransparency = 1
        l.Font = font or Enum.Font.Gotham
        l.TextSize = textSize or 12
        l.TextColor3 = color or Color3.fromRGB(235, 238, 245)
        l.Text = text
        l.TextXAlignment = align or Enum.TextXAlignment.Left
        l.TextWrapped = true
        return l
    end
    parent.CanvasSize = UDim2.new(0, 0, 0, 330)
    parent.ScrollingDirection = Enum.ScrollingDirection.Y
    local content = Instance.new("Frame")
    content.Parent = parent
    content.Size = UDim2.new(1, -24, 0, 310)
    content.Position = UDim2.new(0, 12, 0, 10)
    content.BackgroundTransparency = 1
    local welcome = Instance.new("Frame")
    welcome.Parent = content
    welcome.Size = UDim2.new(1, 0, 0, 150)
    welcome.BackgroundColor3 = Color3.fromRGB(18, 20, 29)
    welcome.BackgroundTransparency = 0.06
    welcome.BorderSizePixel = 0
    corner(welcome, 12)
    stroke(welcome, theme, 1.2, 0.18)
    local glow = Instance.new("Frame")
    glow.Parent = welcome
    glow.Size = UDim2.new(0, 180, 1, 0)
    glow.Position = UDim2.new(1, -180, 0, 0)
    glow.BackgroundColor3 = theme
    glow.BackgroundTransparency = 0.94
    glow.BorderSizePixel = 0
    corner(glow, 12)
    local title = label(welcome, "WELCOME TO FISHHUB", UDim2.new(1, -36, 0, 28), UDim2.new(0, 18, 0, 17), Enum.Font.GothamBold, 20, Color3.fromRGB(245, 247, 252))
    title.TextYAlignment = Enum.TextYAlignment.Center
    local accent = label(welcome, "BLOX FRUITS", UDim2.new(1, -36, 0, 18), UDim2.new(0, 18, 0, 48), Enum.Font.Code, 10, theme)
    local body = label(welcome, "Welcome to the FishHub interface. This Home tab is loaded from a separate remote script, so its content can be updated without rebuilding the main UI.", UDim2.new(1, -36, 0, 48), UDim2.new(0, 18, 0, 72), Enum.Font.Gotham, 12, Color3.fromRGB(180, 185, 198))
    body.TextYAlignment = Enum.TextYAlignment.Top
    local status = Instance.new("Frame")
    status.Parent = content
    status.Size = UDim2.new(1, 0, 0, 68)
    status.Position = UDim2.new(0, 0, 0, 162)
    status.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
    status.BackgroundTransparency = 0.04
    status.BorderSizePixel = 0
    corner(status, 10)
    stroke(status, theme, 1, 0.35)
    local dot = Instance.new("Frame")
    dot.Parent = status
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(0, 16, 0.5, -4)
    dot.BackgroundColor3 = Color3.fromRGB(55, 230, 105)
    dot.BorderSizePixel = 0
    corner(dot, 99)
    task.spawn(function()
        while dot.Parent do
            TweenService:Create(dot, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.65}):Play()
            task.wait(0.7)
            TweenService:Create(dot, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.05}):Play()
            task.wait(0.7)
        end
    end)
    label(status, "FISHHUB STATUS", UDim2.new(0, 160, 0, 18), UDim2.new(0, 32, 0, 12), Enum.Font.GothamBold, 10, Color3.fromRGB(225, 228, 238))
    label(status, "Home module loaded successfully", UDim2.new(1, -210, 0, 18), UDim2.new(0, 32, 0, 33), Enum.Font.Gotham, 10, Color3.fromRGB(145, 150, 165))
    local info = Instance.new("Frame")
    info.Parent = content
    info.Size = UDim2.new(1, 0, 0, 68)
    info.Position = UDim2.new(0, 0, 0, 240)
    info.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
    info.BackgroundTransparency = 0.04
    info.BorderSizePixel = 0
    corner(info, 10)
    stroke(info, theme, 1, 0.35)
    local gameName = "Roblox Game"
    pcall(function()
        local product = MarketplaceService:GetProductInfo(game.PlaceId)
        if product and product.Name then
            gameName = product.Name
        end
    end)
    local playerName = Player and Player.DisplayName or "Player"
    label(info, "GAME", UDim2.new(0, 70, 0, 16), UDim2.new(0, 14, 0, 10), Enum.Font.Code, 9, Color3.fromRGB(130, 136, 152))
    label(info, gameName, UDim2.new(0.48, -20, 0, 18), UDim2.new(0, 14, 0, 29), Enum.Font.GothamBold, 11, Color3.fromRGB(235, 238, 245))
    label(info, "PLAYER", UDim2.new(0, 70, 0, 16), UDim2.new(0.5, 0, 0, 10), Enum.Font.Code, 9, Color3.fromRGB(130, 136, 152))
    label(info, playerName, UDim2.new(0.5, -14, 0, 18), UDim2.new(0.5, 0, 0, 29), Enum.Font.GothamBold, 11, theme)
    if ShowNotification then
        task.defer(function()
            ShowNotification("Home loaded successfully")
        end)
    end
end
