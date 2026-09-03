local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}

local function accent()
    if Config.Rainbow or Config.RainbowMode then
        return Color3.fromHSV((tick() % 5) / 5, 1, 1)
    end
    return typeof(Config.ThemeColor) == "Color3"
        and Config.ThemeColor
        or Color3.fromRGB(0, 229, 255)
end

local function New(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function Corner(parent, radius)
    return New("UICorner", {
        Parent = parent,
        CornerRadius = UDim.new(0, radius)
    })
end

local function Stroke(parent, thickness, transparency)
    return New("UIStroke", {
        Parent = parent,
        Color = accent(),
        Thickness = thickness or 1,
        Transparency = transparency or 0.4,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

local function Gradient(parent, colorSeq, rotation)
    return New("UIGradient", {
        Parent = parent,
        Color = colorSeq,
        Rotation = rotation or 90
    })
end

local function Tween(obj, props, time, style, dir)
    local info = TweenInfo.new(
        time or 0.25,
        style or Enum.EasingStyle.Quad,
        dir or Enum.EasingDirection.Out
    )
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

for _, child in ipairs(Tab:GetChildren()) do
    child:Destroy()
end

Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0

-- ===== Header =====
local header = New("Frame", {
    Parent = Tab,
    Size = UDim2.new(1, 0, 0, 46),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0
})

local headerTitle = New("TextLabel", {
    Parent = header,
    Position = UDim2.fromOffset(4, 4),
    Size = UDim2.new(1, -8, 0, 22),
    BackgroundTransparency = 1,
    Text = "Event Islands",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(245, 247, 252),
    TextXAlignment = Enum.TextXAlignment.Left
})

local headerSub = New("TextLabel", {
    Parent = header,
    Position = UDim2.fromOffset(4, 24),
    Size = UDim2.new(1, -8, 0, 16),
    BackgroundTransparency = 1,
    Text = "Auto-tracking · updates every 3s",
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(130, 135, 150),
    TextXAlignment = Enum.TextXAlignment.Left
})

local headerLine = New("Frame", {
    Parent = header,
    Position = UDim2.new(0, 0, 1, -1),
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = Color3.fromRGB(35, 38, 50),
    BorderSizePixel = 0
})

-- ===== Scroll container =====
local container = New("ScrollingFrame", {
    Parent = Tab,
    Position = UDim2.new(0, 0, 0, 46),
    Size = UDim2.new(1, 0, 1, -46),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = accent()
})

New("UIPadding", {
    Parent = container,
    PaddingTop = UDim.new(0, 6),
    PaddingBottom = UDim.new(0, 15),
    PaddingLeft = UDim.new(0, 2),
    PaddingRight = UDim.new(0, 6)
})

New("UIListLayout", {
    Parent = container,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 10)
})

local eventIslands = {
    {name = "Mirage Island", icon = "🏝️", keywords = {"Mirage", "MysticIsland", "MirageIsland"}},
    {name = "Kitsune Island", icon = "🦊", keywords = {"Kitsune", "KitsuneIsland"}},
    {name = "Prehistoric Island", icon = "🦖", keywords = {"Prehistoric", "PrehistoricIsland"}},
    {name = "Frozen Dimension", icon = "❄️", keywords = {"Frozen", "FrozenDimension", "Leviathan"}}
}

local cards = {}

for i, island in ipairs(eventIslands) do
    local card = New("Frame", {
        Parent = container,
        LayoutOrder = i,
        Size = UDim2.new(1, 0, 0, 68),
        BackgroundColor3 = Color3.fromRGB(16, 18, 26),
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    Corner(card, 14)
    local stroke = Stroke(card, 1, 0.55)

    Gradient(card, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 22, 32)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 19))
    }), 90)

    -- thanh nhấn màu accent bên trái
    local accentBar = New("Frame", {
        Parent = card,
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = accent(),
        BorderSizePixel = 0
    })

    local iconLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(16, 0),
        Size = UDim2.fromOffset(30, 68),
        BackgroundTransparency = 1,
        Text = island.icon,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(54, 14),
        Size = UDim2.new(1, -110, 0, 20),
        BackgroundTransparency = 1,
        Text = island.name,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(245, 247, 252),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local statusLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(54, 36),
        Size = UDim2.new(1, -110, 0, 16),
        BackgroundTransparency = 1,
        Text = "Checking...",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(150, 155, 170),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local badge = New("Frame", {
        Parent = card,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -16, 0.5, 0),
        Size = UDim2.fromOffset(38, 38),
        BackgroundColor3 = Color3.fromRGB(24, 27, 39),
        BorderSizePixel = 0
    })
    Corner(badge, 10)
    local badgeStroke = Stroke(badge, 1.5, 0.35)

    local indicator = New("TextLabel", {
        Parent = badge,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextSize = 17,
        TextColor3 = Color3.fromRGB(255, 90, 90),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    cards[island.name] = {
        card = card,
        stroke = stroke,
        accentBar = accentBar,
        statusLabel = statusLabel,
        badge = badge,
        badgeStroke = badgeStroke,
        indicator = indicator,
        keywords = island.keywords,
        lastFound = nil
    }
end

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

task.spawn(function()
    while alive and container.Parent do
        local a = accent()
        container.ScrollBarImageColor3 = a

        local mapFolder = Workspace:FindFirstChild("Map")
        local seaBeastsFolder = Workspace:FindFirstChild("SeaBeasts")

        for name, data in pairs(cards) do
            Tween(data.stroke, {Color = a}, 0.3)
            Tween(data.badgeStroke, {Color = a}, 0.3)
            Tween(data.accentBar, {BackgroundColor3 = a}, 0.3)

            local found = false

            local function quickCheck(folder)
                if not folder then return false end
                for _, obj in ipairs(folder:GetChildren()) do
                    local objName = obj.Name
                    for _, kw in ipairs(data.keywords) do
                        if objName == kw or string.find(objName, kw) then
                            return true
                        end
                    end
                end
                return false
            end

            if mapFolder and quickCheck(mapFolder) then
                found = true
            end
            if not found and seaBeastsFolder and quickCheck(seaBeastsFolder) then
                found = true
            end

            if found ~= data.lastFound then
                data.lastFound = found
                if found then
                    Tween(data.card, {BackgroundColor3 = Color3.fromRGB(14, 24, 20)}, 0.35)
                    Tween(data.badge, {BackgroundColor3 = Color3.fromRGB(18, 34, 26)}, 0.35)
                else
                    Tween(data.card, {BackgroundColor3 = Color3.fromRGB(16, 18, 26)}, 0.35)
                    Tween(data.badge, {BackgroundColor3 = Color3.fromRGB(24, 27, 39)}, 0.35)
                end
            end

            if found then
                data.indicator.Text = "✓"
                Tween(data.indicator, {TextColor3 = Color3.fromRGB(80, 255, 150)}, 0.3)
                data.statusLabel.Text = "Status: True (Found)"
                Tween(data.statusLabel, {TextColor3 = Color3.fromRGB(150, 255, 190)}, 0.3)
            else
                data.indicator.Text = "×"
                Tween(data.indicator, {TextColor3 = Color3.fromRGB(255, 90, 90)}, 0.3)
                data.statusLabel.Text = "Status: False"
                Tween(data.statusLabel, {TextColor3 = Color3.fromRGB(255, 120, 120)}, 0.3)
            end
        end

        task.wait(3)
    end
end)

return {}
