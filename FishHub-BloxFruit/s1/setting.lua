local TweenService = game:GetService("TweenService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}

local function accent()
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
        Transparency = transparency or 0.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

for _, child in ipairs(Tab:GetChildren()) do
    child:Destroy()
end

Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0
Tab.ScrollBarThickness = 0
Tab.ScrollBarImageTransparency = 1
Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

local root = New("Frame", {
    Parent = Tab,
    Size = UDim2.new(1, -10, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1
})

New("UIPadding", {
    Parent = root,
    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 5)
})

New("UIListLayout", {
    Parent = root,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 10)
})

local searchBox = New("Frame", {
    Parent = root,
    LayoutOrder = 1,
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundColor3 = Color3.fromRGB(12, 13, 19),
    BorderSizePixel = 0
})
Corner(searchBox, 10)
local searchStroke = Stroke(searchBox, 1, 0.4)

New("TextLabel", {
    Parent = searchBox,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.fromOffset(20, 45),
    BackgroundTransparency = 1,
    Text = "🔍",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(185, 190, 205)
})

New("TextBox", {
    Parent = searchBox,
    Position = UDim2.fromOffset(40, 0),
    Size = UDim2.new(1, -50, 1, 0),
    BackgroundTransparency = 1,
    ClearTextOnFocus = false,
    PlaceholderText = "search...",
    PlaceholderColor3 = Color3.fromRGB(100, 105, 120),
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(240, 242, 248),
    TextXAlignment = Enum.TextXAlignment.Left
})

local info = New("Frame", {
    Parent = root,
    LayoutOrder = 2,
    Size = UDim2.new(1, 0, 0, 70),
    BackgroundColor3 = Color3.fromRGB(8, 9, 14),
    BorderSizePixel = 0
})
Corner(info, 12)
local infoStroke = Stroke(info, 1, 0.58)

New("TextLabel", {
    Parent = info,
    Position = UDim2.fromOffset(14, 10),
    Size = UDim2.new(1, -28, 0, 22),
    BackgroundTransparency = 1,
    Text = "SETTING",
    Font = Enum.Font.GothamBlack,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(240, 242, 248),
    TextXAlignment = Enum.TextXAlignment.Left
})

New("TextLabel", {
    Parent = info,
    Position = UDim2.fromOffset(14, 35),
    Size = UDim2.new(1, -28, 0, 22),
    BackgroundTransparency = 1,
    Text = "FishHub settings",
    Font = Enum.Font.GothamMedium,
    TextSize = 9,
    TextColor3 = Color3.fromRGB(120, 125, 140),
    TextXAlignment = Enum.TextXAlignment.Left
})

task.spawn(function()
    while root.Parent do
        local a = accent()
        searchStroke.Color = a
        infoStroke.Color = a
        task.wait(0)
    end
end)

return { Root = Tab }
