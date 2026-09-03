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

for _, child in ipairs(Tab:GetChildren()) do
    child:Destroy()
end

Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0

local container = New("ScrollingFrame", {
    Parent = Tab,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = accent()
})

New("UIPadding", {
    Parent = container,
    PaddingTop = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 15),
    PaddingLeft = UDim.new(0, 2),
    PaddingRight = UDim.new(0, 5)
})

New("UIListLayout", {
    Parent = container,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8)
})

local eventIslands = {
    {name = "Mirage Island", keywords = {"Mirage", "MysticIsland", "MirageIsland"}},
    {name = "Kitsune Island", keywords = {"Kitsune", "KitsuneIsland"}},
    {name = "Prehistoric Island", keywords = {"Prehistoric", "PrehistoricIsland"}},
    {name = "Frozen Dimension", keywords = {"Frozen", "FrozenDimension", "Leviathan"}}
}

local cards = {}

for i, island in ipairs(eventIslands) do
    local card = New("Frame", {
        Parent = container,
        LayoutOrder = i,
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    })
    Corner(card, 12)
    local stroke = Stroke(card, 1, 0.5)

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 12),
        Size = UDim2.new(1, -90, 0, 22),
        BackgroundTransparency = 1,
        Text = island.name,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(240, 242, 248),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local statusLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 36),
        Size = UDim2.new(1, -90, 0, 16),
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
        Position = UDim2.new(1, -15, 0.5, 0),
        Size = UDim2.fromOffset(36, 36),
        BackgroundColor3 = Color3.fromRGB(22, 25, 37),
        BorderSizePixel = 0
    })
    Corner(badge, 8)
    local badgeStroke = Stroke(badge, 1, 0.4)

    local indicator = New("TextLabel", {
        Parent = badge,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 90, 90),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    cards[island.name] = {
        card = card,
        stroke = stroke,
        statusLabel = statusLabel,
        badge = badge,
        badgeStroke = badgeStroke,
        indicator = indicator,
        keywords = island.keywords
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
            data.stroke.Color = a
            data.badgeStroke.Color = a
            
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

            if found then
                data.indicator.Text = "✓"
                data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                data.statusLabel.Text = "Status: True (Found)"
                data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
            else
                data.indicator.Text = "×"
                data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                data.statusLabel.Text = "Status: False"
                data.statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
            end
        end

        task.wait(3)
    end
end)

return {}
