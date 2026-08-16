-- FishHub | Decorated Home Module
-- UI-only: Welcome / Script Information / Current Game / Player

return function(ctx)
    local container = ctx.Container
    local TweenService = ctx.TweenService
    local Players = ctx.Players
    local player = Players.LocalPlayer
    local theme = ctx.ThemeColor()
    local MarketplaceService = game:GetService("MarketplaceService")

    for _, child in ipairs(container:GetChildren()) do child:Destroy() end

    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)

    local padding = Instance.new("UIPadding")
    padding.Parent = container
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 16)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)

    local function corner(p, r)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, r or 10)
        c.Parent = p
    end

    local function makeStroke(p, transparency, thickness)
        local s = Instance.new("UIStroke")
        s.Color = theme
        s.Transparency = transparency or .7
        s.Thickness = thickness or 1
        s.Parent = p
    end

    local function text(p, value, size, pos, font, ts, color)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Text = value
        l.Size = size
        l.Position = pos
        l.Font = font or Enum.Font.GothamMedium
        l.TextSize = ts or 11
        l.TextColor3 = color or Color3.fromRGB(220,223,235)
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = p
        return l
    end

    local function card(height, order)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -10, 0, height)
        f.BackgroundColor3 = Color3.fromRGB(15,17,24)
        f.BorderSizePixel = 0
        f.LayoutOrder = order
        f.Parent = container
        corner(f, 12)
        makeStroke(f)
        return f
    end

    local gameName, creatorName, description = "Unknown Game", "Unknown Creator", "No game description available."
    pcall(function()
        local info = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset)
        if info then
            gameName = info.Name or gameName
            description = info.Description or description
            if info.Creator and info.Creator.Name then creatorName = info.Creator.Name end
        end
    end)

    -- Welcome
    local hero = card(130, 1)
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0,4,1,-24)
    bar.Position = UDim2.fromOffset(10,12)
    bar.BackgroundColor3 = theme
    bar.BorderSizePixel = 0
    bar.Parent = hero
    corner(bar,3)

    text(hero,"WELCOME BACK",UDim2.new(1,-42,0,28),UDim2.fromOffset(26,14),Enum.Font.GothamBlack,20,Color3.fromRGB(242,244,250))
    local fish = text(hero,"FISHHUB",UDim2.new(0,100,0,22),UDim2.new(1,-112,0,17),Enum.Font.GothamBlack,11,theme)
    fish.TextXAlignment = Enum.TextXAlignment.Right
    text(hero,"Hello, "..tostring(player.DisplayName).."  @"..tostring(player.Name),UDim2.new(1,-42,0,20),UDim2.fromOffset(26,47),Enum.Font.GothamBold,11,theme)
    text(hero,"A clean modular hub for your current Roblox experience.",UDim2.new(1,-42,0,20),UDim2.fromOffset(26,72),Enum.Font.GothamMedium,10,Color3.fromRGB(155,160,175))

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1,-52,0,1)
    line.Position = UDim2.fromOffset(26,99)
    line.BackgroundColor3 = theme
    line.BackgroundTransparency = .72
    line.BorderSizePixel = 0
    line.Parent = hero
    text(hero,"HOME  •  SCRIPT  •  GAME",UDim2.new(1,-42,0,15),UDim2.fromOffset(26,106),Enum.Font.GothamBold,8,Color3.fromRGB(110,115,135))

    -- Script information
    local scriptCard = card(145, 2)
    text(scriptCard,"SCRIPT INFORMATION",UDim2.new(1,-28,0,20),UDim2.fromOffset(14,10),Enum.Font.GothamBold,12,theme)
    text(scriptCard,"FishHub",UDim2.new(.5,0,0,24),UDim2.fromOffset(14,37),Enum.Font.GothamBlack,17,Color3.fromRGB(238,240,248))
    local modular = text(scriptCard,"MODULAR BUILD",UDim2.new(.5,-14,0,18),UDim2.new(.5,0,0,41),Enum.Font.GothamBold,8,theme)
    modular.TextXAlignment = Enum.TextXAlignment.Right
    local desc = text(scriptCard,"Home / Function / Creative are separated into independent UI modules for a cleaner layout.",UDim2.new(1,-28,0,35),UDim2.fromOffset(14,67),Enum.Font.GothamMedium,9,Color3.fromRGB(150,155,170))
    desc.TextWrapped = true
    text(scriptCard,"STATUS     READY",UDim2.new(.5,-14,0,18),UDim2.fromOffset(14,116),Enum.Font.Code,9,Color3.fromRGB(110,235,165))
    local build = text(scriptCard,"UI MODULE",UDim2.new(.5,-14,0,18),UDim2.new(.5,0,0,116),Enum.Font.Code,9,Color3.fromRGB(115,120,140))
    build.TextXAlignment = Enum.TextXAlignment.Right

    -- Current game
    local gameCard = card(174, 3)
    text(gameCard,"CURRENT GAME",UDim2.new(1,-28,0,20),UDim2.fromOffset(14,10),Enum.Font.GothamBold,12,theme)

    local thumb = Instance.new("ImageLabel")
    thumb.Size = UDim2.fromOffset(80,80)
    thumb.Position = UDim2.fromOffset(14,40)
    thumb.BackgroundColor3 = Color3.fromRGB(27,30,40)
    thumb.BorderSizePixel = 0
    thumb.Image = "https://www.roblox.com/asset-thumbnail/image?assetId="..tostring(game.PlaceId).."&width=420&height=420&format=png"
    thumb.ScaleType = Enum.ScaleType.Crop
    thumb.Parent = gameCard
    corner(thumb,10)
    makeStroke(thumb,.45,1)

    local gn = text(gameCard,gameName,UDim2.new(1,-110,0,25),UDim2.fromOffset(106,41),Enum.Font.GothamBlack,14,Color3.fromRGB(238,240,248))
    gn.TextTruncate = Enum.TextTruncate.AtEnd
    local cr = text(gameCard,"By  "..creatorName,UDim2.new(1,-110,0,18),UDim2.fromOffset(106,69),Enum.Font.GothamMedium,9,theme)
    cr.TextTruncate = Enum.TextTruncate.AtEnd
    text(gameCard,"PLACE ID  "..tostring(game.PlaceId),UDim2.new(1,-110,0,18),UDim2.fromOffset(106,90),Enum.Font.Code,8,Color3.fromRGB(120,125,140))

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1,-28,0,1)
    sep.Position = UDim2.fromOffset(14,128)
    sep.BackgroundColor3 = theme
    sep.BackgroundTransparency = .82
    sep.BorderSizePixel = 0
    sep.Parent = gameCard

    local gd = text(gameCard,description ~= "" and description or "No description available.",UDim2.new(1,-28,0,34),UDim2.fromOffset(14,137),Enum.Font.GothamMedium,8,Color3.fromRGB(135,140,155))
    gd.TextWrapped = true
    gd.TextTruncate = Enum.TextTruncate.AtEnd

    -- Player
    local playerCard = card(86, 4)
    text(playerCard,"PLAYER",UDim2.new(.5,-20,0,18),UDim2.fromOffset(14,10),Enum.Font.GothamBold,10,theme)
    text(playerCard,tostring(player.DisplayName),UDim2.new(.5,-20,0,22),UDim2.fromOffset(14,33),Enum.Font.GothamBlack,13,Color3.fromRGB(235,238,247))
    local pid = text(playerCard,"@"..tostring(player.Name).."  •  UserId: "..tostring(player.UserId),UDim2.new(1,-28,0,16),UDim2.fromOffset(14,59),Enum.Font.Code,8,Color3.fromRGB(120,125,140))
    pid.TextTruncate = Enum.TextTruncate.AtEnd
    local online = text(playerCard,"● ONLINE",UDim2.new(.5,-20,0,20),UDim2.new(.5,0,0,31),Enum.Font.GothamBold,9,Color3.fromRGB(110,235,165))
    online.TextXAlignment = Enum.TextXAlignment.Right

    -- Entrance animation
    local cards = {}
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("GuiObject") then table.insert(cards, child) end
    end
    for i, item in ipairs(cards) do
        local original = item.Position
        local transparency = item.BackgroundTransparency
        item.Position = UDim2.new(0,18,original.Y.Scale,original.Y.Offset)
        item.BackgroundTransparency = 1
        task.delay((i-1)*.055,function()
            if item and item.Parent then
                TweenService:Create(item,TweenInfo.new(.34,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
                    Position=original, BackgroundTransparency=transparency
                }):Play()
            end
        end)
    end

    task.spawn(function()
        while container.Parent do
            TweenService:Create(bar,TweenInfo.new(1.15,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=.35}):Play()
            task.wait(1.15)
            if not container.Parent then break end
            TweenService:Create(bar,TweenInfo.new(1.15,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=0}):Play()
            task.wait(1.15)
        end
    end)
end
