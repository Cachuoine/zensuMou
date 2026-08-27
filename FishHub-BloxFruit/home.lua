local ctx = ...
if type(ctx) ~= "table" then return end

local Tab = ctx.Tab
local Main = ctx.Main
local Config = ctx.Config
local Players = ctx.Players
local TweenService = ctx.TweenService
local HttpService = ctx.HttpService
local MarketplaceService = ctx.MarketplaceService
local UserInputService = ctx.UserInputService
local ShowNotification = ctx.ShowNotification
local Stats = game:GetService("Stats")
local Player = Players.LocalPlayer

local THEME = (Config and Config.ThemeColor) or Color3.fromRGB(0, 229, 255)
local BG_CARD = Color3.fromRGB(28, 30, 42)
local BG_INNER = Color3.fromRGB(20, 22, 32)
local TEXT_MAIN = Color3.fromRGB(240, 244, 252)
local TEXT_DIM = Color3.fromRGB(165, 172, 190)
local ACCENT_SOFT = Color3.fromRGB(60, 65, 85)

local function AddCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.Parent = parent
    c.CornerRadius = UDim.new(0, radius or 10)
    return c
end

local function AddStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Parent = parent
    s.Color = color or THEME
    s.Thickness = thickness or 1.2
    s.Transparency = transparency or 0.3
    return s
end

local function MakeLabel(parent, props)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = parent
    lbl.BackgroundTransparency = 1
    lbl.Font = props.font or Enum.Font.GothamMedium
    lbl.TextSize = props.size or 12
    lbl.TextColor3 = props.color or TEXT_MAIN
    lbl.Text = props.text or ""
    lbl.TextXAlignment = props.alignX or Enum.TextXAlignment.Left
    lbl.TextYAlignment = props.alignY or Enum.TextYAlignment.Center
    lbl.Size = props.size_ or UDim2.new(1, 0, 0, 18)
    lbl.Position = props.pos or UDim2.new(0, 0, 0, 0)
    lbl.TextWrapped = props.wrap or false
    lbl.RichText = props.rich or false
    return lbl
end

local function AddPaddingScrollingFrame(sf, left, right, top, bottom)
    local p = Instance.new("UIPadding")
    p.Parent = sf
    p.PaddingLeft = UDim.new(0, left or 14)
    p.PaddingRight = UDim.new(0, right or 14)
    p.PaddingTop = UDim.new(0, top or 14)
    p.PaddingBottom = UDim.new(0, bottom or 14)
    return p
end

local function MakeToggle(parent, title, default, callback)
    local card = Instance.new("Frame")
    card.Parent = parent
    card.Size = UDim2.new(1, 0, 0, 40)
    card.BackgroundColor3 = BG_CARD
    card.BorderSizePixel = 0
    AddCorner(card, 8)
    AddStroke(card, THEME, 1, 0.6)
    local titleLbl = MakeLabel(card, {
        text = title, size = 12, color = TEXT_MAIN,
        size_ = UDim2.new(1, -64, 1, 0), pos = UDim2.new(0, 14, 0, 0)
    })
    local toggleBg = Instance.new("Frame")
    toggleBg.Parent = card
    toggleBg.Size = UDim2.new(0, 40, 0, 22)
    toggleBg.Position = UDim2.new(1, -52, 0.5, 0)
    toggleBg.AnchorPoint = Vector2.new(0, 0.5)
    toggleBg.BackgroundColor3 = default and THEME or Color3.fromRGB(50, 54, 70)
    toggleBg.BorderSizePixel = 0
    AddCorner(toggleBg, 999)
    local knob = Instance.new("Frame")
    knob.Parent = toggleBg
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = default and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    AddCorner(knob, 999)
    local state = default and true or false
    local function fire(anim)
        if anim then
            TweenService:Create(toggleBg, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                BackgroundColor3 = state and THEME or Color3.fromRGB(50, 54, 70)
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            }):Play()
        end
        if callback then callback(state) end
    end
    fire(false)
    local btn = Instance.new("TextButton")
    btn.Parent = card
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 5
    btn.MouseButton1Click:Connect(function()
        state = not state
        fire(true)
    end)
    return card
end

local function MakeActionButton(parent, title, subtitle, color, callback)
    local card = Instance.new("Frame")
    card.Parent = parent
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = BG_CARD
    card.BorderSizePixel = 0
    AddCorner(card, 10)
    local stroke = AddStroke(card, color or THEME, 1.2, 0.4)
    local accent = Instance.new("Frame")
    accent.Parent = card
    accent.Size = UDim2.new(0, 3, 1, -16)
    accent.Position = UDim2.new(0, 10, 0, 8)
    accent.BackgroundColor3 = color or THEME
    accent.BorderSizePixel = 0
    AddCorner(accent, 999)
    local titleLbl = MakeLabel(card, {
        text = title, size = 13, color = TEXT_MAIN, font = Enum.Font.GothamBold,
        size_ = UDim2.new(1, -30, 0, 20), pos = UDim2.new(0, 22, 0, 10)
    })
    local subLbl = MakeLabel(card, {
        text = subtitle, size = 10, color = TEXT_DIM,
        size_ = UDim2.new(1, -30, 0, 16), pos = UDim2.new(0, 22, 0, 30)
    })
    local btn = Instance.new("TextButton")
    btn.Parent = card
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 5
    btn.MouseEnter:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.18), {Transparency = 0.05, Thickness = 1.6}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.18), {Transparency = 0.4, Thickness = 1.2}):Play()
    end)
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    return card
end

local function MakeStatTile(parent, title, value, color, icon)
    local tile = Instance.new("Frame")
    tile.Parent = parent
    tile.BackgroundColor3 = BG_CARD
    tile.BorderSizePixel = 0
    AddCorner(tile, 10)
    AddStroke(tile, color or THEME, 1, 0.5)
    local iconLbl = MakeLabel(tile, {
        text = icon or "★", size = 18, color = color or THEME, font = Enum.Font.GothamBold,
        size_ = UDim2.new(0, 30, 0, 30), pos = UDim2.new(0, 10, 0.5, 0),
        alignX = Enum.TextXAlignment.Center
    })
    iconLbl.AnchorPoint = Vector2.new(0, 0.5)
    local titleLbl = MakeLabel(tile, {
        text = title, size = 9, color = TEXT_DIM, font = Enum.Font.GothamBold,
        size_ = UDim2.new(1, -50, 0, 12), pos = UDim2.new(0, 44, 0, 12)
    })
    local valueLbl = MakeLabel(tile, {
        text = value or "--", size = 13, color = TEXT_MAIN, font = Enum.Font.Code,
        size_ = UDim2.new(1, -50, 0, 18), pos = UDim2.new(0, 44, 0, 26)
    })
    return tile, valueLbl
end

local list = Instance.new("UIListLayout")
list.Parent = Tab
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding = UDim.new(0, 10)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
AddPaddingScrollingFrame(Tab, 14, 14, 14, 14)
Tab.ScrollBarThickness = 4
Tab.ScrollBarImageColor3 = THEME

local layoutOrder = 0
local function nextOrder()
    layoutOrder = layoutOrder + 1
    return layoutOrder
end

local hero = Instance.new("Frame")
hero.Parent = Tab
hero.Size = UDim2.new(1, 0, 0, 110)
hero.BackgroundColor3 = BG_CARD
hero.BorderSizePixel = 0
hero.LayoutOrder = nextOrder()
AddCorner(hero, 14)
local heroStroke = AddStroke(hero, THEME, 1.5, 0.1)
local heroGradient = Instance.new("UIGradient")
heroGradient.Parent = hero
heroGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 38, 56)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 20, 30))
})
heroGradient.Rotation = 90
local welcome = MakeLabel(hero, {
    text = "🐟  WELCOME TO FISHHUB", size = 11, color = THEME, font = Enum.Font.GothamBold,
    size_ = UDim2.new(1, -28, 0, 14), pos = UDim2.new(0, 14, 0, 14)
})
local greeting = MakeLabel(hero, {
    text = "Hi, " .. (Player and Player.DisplayName or "Player") .. " 👋", size = 18, color = TEXT_MAIN, font = Enum.Font.GothamBold,
    size_ = UDim2.new(1, -28, 0, 24), pos = UDim2.new(0, 14, 0, 32)
})
local subgreeting = MakeLabel(hero, {
    text = "Your hub is loaded and ready. Use the tabs to switch tools.", size = 11, color = TEXT_DIM,
    size_ = UDim2.new(1, -28, 0, 16), pos = UDim2.new(0, 14, 0, 60)
})
local verBadge = MakeLabel(hero, {
    text = "v1.0 • STABLE", size = 9, color = THEME, font = Enum.Font.Code, rich = true,
    size_ = UDim2.new(0, 110, 0, 20), pos = UDim2.new(1, -124, 0, 14)
})
verBadge.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
verBadge.BackgroundTransparency = 0.3
AddCorner(verBadge, 6)

task.spawn(function()
    while hero and hero.Parent do
        TweenService:Create(heroStroke, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.5}):Play()
        task.wait(1.6)
        TweenService:Create(heroStroke, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play()
        task.wait(1.6)
    end
end)

local statsRow1 = Instance.new("Frame")
statsRow1.Parent = Tab
statsRow1.Size = UDim2.new(1, 0, 0, 60)
statsRow1.BackgroundTransparency = 1
statsRow1.LayoutOrder = nextOrder()
local s1 = Instance.new("UIListLayout")
s1.Parent = statsRow1
s1.FillDirection = Enum.FillDirection.Horizontal
s1.Padding = UDim.new(0, 8)
s1.SortOrder = Enum.SortOrder.LayoutOrder

local tile1, val1 = MakeStatTile(statsRow1, "SERVER", "0/0", Color3.fromRGB(140, 180, 255), "👥")
tile1.Size = UDim2.new(0.5, -4, 1, 0)
tile1.LayoutOrder = 1
local tile2, val2 = MakeStatTile(statsRow1, "PING", "0 ms", Color3.fromRGB(255, 200, 90), "📡")
tile2.Size = UDim2.new(0.5, -4, 1, 0)
tile2.LayoutOrder = 2

local statsRow2 = Instance.new("Frame")
statsRow2.Parent = Tab
statsRow2.Size = UDim2.new(1, 0, 0, 60)
statsRow2.BackgroundTransparency = 1
statsRow2.LayoutOrder = nextOrder()
local s2 = Instance.new("UIListLayout")
s2.Parent = statsRow2
s2.FillDirection = Enum.FillDirection.Horizontal
s2.Padding = UDim.new(0, 8)
s2.SortOrder = Enum.SortOrder.LayoutOrder

local tile3, val3 = MakeStatTile(statsRow2, "FPS", "60", Color3.fromRGB(120, 230, 130), "⚡")
tile3.Size = UDim2.new(0.5, -4, 1, 0)
tile3.LayoutOrder = 1
local tile4, val4 = MakeStatTile(statsRow2, "GAME", "Loading...", Color3.fromRGB(190, 140, 255), "🎮")
tile4.Size = UDim2.new(0.5, -4, 1, 0)
tile4.LayoutOrder = 2

task.spawn(function()
    while Tab and Tab.Parent do
        local count = #Players:GetPlayers()
        val1.Text = count .. "/" .. tostring(Players.MaxPlayers)
        local ping = 0
        pcall(function()
            local perf = Stats.PerformanceStats
            if perf and perf.Ping then ping = math.floor(perf.Ping:GetValue()) end
        end)
        if ping <= 0 then
            pcall(function() ping = math.floor(Player:GetNetworkPing() * 1000) end)
        end
        val2.Text = tostring(ping) .. " ms"
        task.wait(1.5)
    end
end)

task.spawn(function()
    local frames, last = 0, tick()
    while Tab and Tab.Parent do
        frames = frames + 1
        local now = tick()
        if now - last >= 1 then
            val3.Text = tostring(math.floor(frames / (now - last) + 0.5))
            frames, last = 0, now
        end
        game:GetService("RunService").RenderStepped:Wait()
    end
end)

task.spawn(function()
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if ok and info and info.Name then
        val4.Text = info.Name
    else
        val4.Text = "Roblox"
    end
end)

local function SectionHeader(parent, text, order)
    local h = Instance.new("Frame")
    h.Parent = parent
    h.Size = UDim2.new(1, 0, 0, 22)
    h.BackgroundTransparency = 1
    h.LayoutOrder = order or nextOrder()
    local lbl = MakeLabel(h, {
        text = text, size = 10, color = TEXT_DIM, font = Enum.Font.GothamBold,
        size_ = UDim2.new(1, 0, 1, 0), pos = UDim2.new(0, 4, 0, 0)
    })
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return h
end

SectionHeader(Tab, "⚡ QUICK ACTIONS", nextOrder())

MakeActionButton(Tab, "Rejoin Server", "Hop back into the same place instantly", Color3.fromRGB(120, 200, 255), function()
    pcall(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
    end)
end)
MakeActionButton(Tab, "Copy Game Link", "Copy this place link to your clipboard", Color3.fromRGB(180, 140, 255), function()
    local link = "https://www.roblox.com/games/" .. tostring(game.PlaceId)
    pcall(function()
        if setclipboard then setclipboard(link) end
    end)
    if ShowNotification then ShowNotification("Copied game link!") end
end)
MakeActionButton(Tab, "Copy Player ID", "Copy your user id for sharing", Color3.fromRGB(255, 180, 100), function()
    if not Player then return end
    pcall(function()
        if setclipboard then setclipboard(tostring(Player.UserId)) end
    end)
    if ShowNotification then ShowNotification("Copied user id!") end
end)

SectionHeader(Tab, "🛠 HUB SETTINGS", nextOrder())

local hideOthers = false
MakeToggle(Tab, "Hide other players' nametags", false, function(state)
    hideOthers = state
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local billboard = head:FindFirstChildOfClass("BillboardGui")
                if billboard then billboard.Enabled = not state end
            end
        end
    end
end)

local fullbrightOn = false
MakeToggle(Tab, "Fullbright (remove shadows)", false, function(state)
    fullbrightOn = state
    pcall(function()
        local lighting = game:GetService("Lighting")
        if state then
            lighting.Brightness = 2
            lighting.GlobalShadows = false
            lighting.FogEnd = 9e9
        else
            lighting.Brightness = 1
            lighting.GlobalShadows = true
            lighting.FogEnd = 100000
        end
    end)
end)

Tab.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Tab.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
end)
