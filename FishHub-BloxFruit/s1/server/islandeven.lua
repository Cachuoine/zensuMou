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
        Transparency = transparency or 0.45,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

for _, child in ipairs(Tab:GetChildren()) do
    child:Destroy()
end

Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0

local scroll = New("ScrollingFrame", {
    Parent = Tab,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = accent(),
    ScrollBarImageTransparency = 0.15
})

New("UIPadding", {
    Parent = scroll,
    PaddingTop = UDim.new(0, 6),
    PaddingBottom = UDim.new(0, 14),
    PaddingLeft = UDim.new(0, 3),
    PaddingRight = UDim.new(0, 6)
})

New("UIListLayout", {
    Parent = scroll,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8)
})

local hero = New("Frame", {
    Parent = scroll,
    LayoutOrder = 0,
    Size = UDim2.new(1, 0, 0, 72),
    BackgroundColor3 = Color3.fromRGB(11, 13, 19),
    BorderSizePixel = 0
})
Corner(hero, 14)
local heroStroke = Stroke(hero, 1, 0.4)

local heroDot = New("Frame", {
    Parent = hero,
    Position = UDim2.fromOffset(14, 18),
    Size = UDim2.fromOffset(34, 34),
    BackgroundColor3 = Color3.fromRGB(20, 24, 34),
    BorderSizePixel = 0
})
Corner(heroDot, 17)
local heroDotStroke = Stroke(heroDot, 1, 0.15)

New("TextLabel", {
    Parent = heroDot,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "✦",
    Font = Enum.Font.GothamBlack,
    TextSize = 17,
    TextColor3 = accent(),
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center
})

New("TextLabel", {
    Parent = hero,
    Position = UDim2.fromOffset(60, 13),
    Size = UDim2.new(1, -72, 0, 18),
    BackgroundTransparency = 1,
    Text = "ISLAND EVENT",
    Font = Enum.Font.GothamBlack,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(242, 244, 250),
    TextXAlignment = Enum.TextXAlignment.Left
})

New("TextLabel", {
    Parent = hero,
    Position = UDim2.fromOffset(60, 34),
    Size = UDim2.new(1, -72, 0, 22),
    BackgroundTransparency = 1,
    Text = "Live event presence monitor",
    Font = Enum.Font.Gotham,
    TextSize = 9,
    TextColor3 = Color3.fromRGB(125, 131, 147),
    TextXAlignment = Enum.TextXAlignment.Left
})

local islands = {
    {name = "Mirage Island", keys = {"Mirage", "MysticIsland", "MirageIsland"}},
    {name = "Kitsune Island", keys = {"Kitsune", "KitsuneIsland"}},
    {name = "Prehistoric Island", keys = {"Prehistoric", "PrehistoricIsland"}},
    {name = "Frozen Dimension", keys = {"Frozen", "FrozenDimension", "Leviathan"}}
}

local cards = {}

local function makeIslandCard(index, info)
    local card = New("Frame", {
        Parent = scroll,
        LayoutOrder = index,
        Size = UDim2.new(1, 0, 0, 69),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    })
    Corner(card, 13)
    local stroke = Stroke(card, 1, 0.5)

    local icon = New("Frame", {
        Parent = card,
        Position = UDim2.fromOffset(12, 15),
        Size = UDim2.fromOffset(39, 39),
        BackgroundColor3 = Color3.fromRGB(20, 23, 32),
        BorderSizePixel = 0
    })
    Corner(icon, 11)
    local iconStroke = Stroke(icon, 1, 0.35)

    local iconText = New("TextLabel", {
        Parent = icon,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "✦",
        Font = Enum.Font.GothamBlack,
        TextSize = 15,
        TextColor3 = accent(),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(62, 10),
        Size = UDim2.new(1, -128, 0, 19),
        BackgroundTransparency = 1,
        Text = info.name,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(239, 241, 247),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local status = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(62, 33),
        Size = UDim2.new(1, -128, 0, 18),
        BackgroundTransparency = 1,
        Text = "Checking...",
        Font = Enum.Font.GothamMedium,
        TextSize = 9,
        TextColor3 = Color3.fromRGB(130, 136, 151),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local badge = New("Frame", {
        Parent = card,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(39, 39),
        BackgroundColor3 = Color3.fromRGB(20, 23, 32),
        BorderSizePixel = 0
    })
    Corner(badge, 12)
    local badgeStroke = Stroke(badge, 1, 0.35)

    local mark = New("TextLabel", {
        Parent = badge,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "×",
        Font = Enum.Font.GothamBlack,
        TextSize = 17,
        TextColor3 = Color3.fromRGB(255, 92, 92),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    cards[info.name] = {
        stroke = stroke,
        iconStroke = iconStroke,
        iconText = iconText,
        badgeStroke = badgeStroke,
        mark = mark,
        status = status,
        keys = info.keys
    }
end

for i, info in ipairs(islands) do
    makeIslandCard(i, info)
end

local function findEvent()
    local candidates = {
        Workspace:FindFirstChild("Map"),
        Workspace:FindFirstChild("SeaBeasts")
    }

    for _, folder in ipairs(candidates) do
        if folder then
            for _, obj in ipairs(folder:GetDescendants()) do
                for _, key in ipairs(currentKeys or {}) do
                    if obj.Name == key or string.find(obj.Name, key, 1, true) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

task.spawn(function()
    while alive and scroll.Parent do
        local a = accent()
        scroll.ScrollBarImageColor3 = a
        heroStroke.Color = a
        heroDotStroke.Color = a

        for name, card in pairs(cards) do
            card.stroke.Color = a
            card.iconStroke.Color = a
            card.badgeStroke.Color = a
            card.iconText.TextColor3 = a

            local found = false
            local map = Workspace:FindFirstChild("Map")
            local beasts = Workspace:FindFirstChild("SeaBeasts")

            local function checkFolder(folder)
                if not folder then return false end
                for _, obj in ipairs(folder:GetDescendants()) do
                    for _, key in ipairs(card.keys) do
                        if obj.Name == key or string.find(obj.Name, key, 1, true) then
                            return true
                        end
                    end
                end
                return false
            end

            found = checkFolder(map) or checkFolder(beasts)

            if found then
                card.mark.Text = "✓"
                card.mark.TextColor3 = Color3.fromRGB(80, 255, 120)
                card.status.Text = "Status: True  •  Event found"
                card.status.TextColor3 = Color3.fromRGB(175, 255, 190)
            else
                card.mark.Text = "×"
                card.mark.TextColor3 = Color3.fromRGB(255, 92, 92)
                card.status.Text = "Status: False  •  Not found"
                card.status.TextColor3 = Color3.fromRGB(130, 136, 151)
            end
        end

        task.wait(1)
    end
end)

return {}
