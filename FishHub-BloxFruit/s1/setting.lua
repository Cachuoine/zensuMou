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
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
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

local function Tween(obj, duration, props, style, direction)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(
            duration or 0.2,
            style or Enum.EasingStyle.Quint,
            direction or Enum.EasingDirection.Out
        ),
        props
    )
    t:Play()
    return t
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

-- Back + Search: giữ cùng cấu trúc với các module khác.
local topBar = New("Frame", {
    Parent = root,
    LayoutOrder = 1,
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundTransparency = 1
})

local backBtn = New("TextButton", {
    Parent = topBar,
    Size = UDim2.fromOffset(45, 45),
    BackgroundColor3 = Color3.fromRGB(10, 12, 18),
    AutoButtonColor = false,
    Text = "",
    BorderSizePixel = 0
})
Corner(backBtn, 11)
local backStroke = Stroke(backBtn, 1, 0.38)

New("UIGradient", {
    Parent = backBtn,
    Rotation = 135,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 25, 36)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 10, 15))
    })
})

local arrow = New("TextLabel", {
    Parent = backBtn,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "←",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = accent()
})

local backScale = New("UIScale", {
    Parent = backBtn,
    Scale = 1
})

local searchBox = New("Frame", {
    Parent = topBar,
    Position = UDim2.new(0, 55, 0, 0),
    Size = UDim2.new(1, -55, 1, 0),
    BackgroundColor3 = Color3.fromRGB(10, 12, 18),
    BorderSizePixel = 0
})
Corner(searchBox, 11)
local searchStroke = Stroke(searchBox, 1, 0.38)

New("UIGradient", {
    Parent = searchBox,
    Rotation = 12,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 23, 32)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(11, 13, 19)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 9, 14))
    })
})

local searchIcon = New("TextLabel", {
    Parent = searchBox,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.fromOffset(20, 45),
    BackgroundTransparency = 1,
    Text = "⌕",
    Font = Enum.Font.GothamBold,
    TextSize = 19,
    TextColor3 = accent()
})

New("TextBox", {
    Parent = searchBox,
    Position = UDim2.fromOffset(40, 0),
    Size = UDim2.new(1, -52, 1, 0),
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

-- Main setting card.
local card = New("Frame", {
    Parent = root,
    LayoutOrder = 2,
    Size = UDim2.new(1, 0, 0, 132),
    BackgroundColor3 = Color3.fromRGB(8, 9, 14),
    BorderSizePixel = 0,
    ClipsDescendants = true
})
Corner(card, 14)
local cardStroke = Stroke(card, 1, 0.52)

New("UIGradient", {
    Parent = card,
    Rotation = 18,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 23, 33)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(10, 11, 17)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 7, 12))
    })
})

local accentBar = New("Frame", {
    Parent = card,
    Position = UDim2.fromOffset(13, 15),
    Size = UDim2.fromOffset(4, 45),
    BackgroundColor3 = accent(),
    BorderSizePixel = 0
})
Corner(accentBar, 4)

local glow = New("Frame", {
    Parent = card,
    Position = UDim2.new(1, -48, 0, 16),
    Size = UDim2.fromOffset(34, 34),
    BackgroundColor3 = accent(),
    BackgroundTransparency = 0.9,
    BorderSizePixel = 0
})
Corner(glow, 99)

local glowStroke = Stroke(glow, 1, 0.55)

New("TextLabel", {
    Parent = card,
    Position = UDim2.fromOffset(28, 10),
    Size = UDim2.new(1, -90, 0, 25),
    BackgroundTransparency = 1,
    Text = "SETTING",
    Font = Enum.Font.GothamBlack,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(245, 246, 252),
    TextXAlignment = Enum.TextXAlignment.Left
})

New("TextLabel", {
    Parent = card,
    Position = UDim2.fromOffset(28, 37),
    Size = UDim2.new(1, -55, 0, 20),
    BackgroundTransparency = 1,
    Text = "FISHHUB  •  SETTINGS & CONTROLS",
    Font = Enum.Font.GothamMedium,
    TextSize = 8,
    TextColor3 = Color3.fromRGB(125, 130, 145),
    TextXAlignment = Enum.TextXAlignment.Left
})

local divider = New("Frame", {
    Parent = card,
    Position = UDim2.fromOffset(15, 72),
    Size = UDim2.new(1, -30, 0, 1),
    BackgroundColor3 = Color3.fromRGB(45, 48, 60),
    BorderSizePixel = 0
})

New("TextLabel", {
    Parent = card,
    Position = UDim2.fromOffset(15, 84),
    Size = UDim2.new(1, -30, 0, 18),
    BackgroundTransparency = 1,
    Text = "Configure your FishHub experience from the main settings panel.",
    Font = Enum.Font.GothamMedium,
    TextSize = 9,
    TextColor3 = Color3.fromRGB(145, 150, 165),
    TextXAlignment = Enum.TextXAlignment.Left
})

New("TextLabel", {
    Parent = card,
    Position = UDim2.fromOffset(15, 104),
    Size = UDim2.new(1, -30, 0, 15),
    BackgroundTransparency = 1,
    Text = "READY  •  SETTINGS MODULE",
    Font = Enum.Font.GothamBold,
    TextSize = 7,
    TextColor3 = accent(),
    TextXAlignment = Enum.TextXAlignment.Left
})

backBtn.MouseEnter:Connect(function()
    Tween(backScale, 0.16, {Scale = 1.06}, Enum.EasingStyle.Back)
    Tween(backStroke, 0.16, {Transparency = 0.05, Thickness = 1.5})
end)

backBtn.MouseLeave:Connect(function()
    Tween(backScale, 0.16, {Scale = 1}, Enum.EasingStyle.Quint)
    Tween(backStroke, 0.16, {Transparency = 0.38, Thickness = 1})
end)

backBtn.Activated:Connect(function()
    Tween(backScale, 0.08, {Scale = 0.94}, Enum.EasingStyle.Quad)
    task.delay(0.08, function()
        if backScale.Parent then
            Tween(backScale, 0.14, {Scale = 1}, Enum.EasingStyle.Back)
        end
    end)

    if type(context.BackToMain) == "function" then
        context.BackToMain()
    elseif type(context.LoadFunction) == "function" then
        context.LoadFunction()
    end
end)

task.spawn(function()
    while root.Parent do
        local a = accent()

        backStroke.Color = a
        searchStroke.Color = a
        cardStroke.Color = a
        glowStroke.Color = a

        arrow.TextColor3 = a
        searchIcon.TextColor3 = a
        accentBar.BackgroundColor3 = a
        glow.BackgroundColor3 = a
        divider.BackgroundColor3 = a

        task.wait(0)
    end
end)

return { Root = Tab }
