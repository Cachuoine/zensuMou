local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}

local function accent()
    return typeof(Config.ThemeColor) == "Color3" and Config.ThemeColor or Color3.fromRGB(0, 229, 255)
end

local function New(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function Corner(parent, radius)
    return New("UICorner", { Parent = parent, CornerRadius = UDim.new(0, radius) })
end

local function Stroke(parent, thickness, transparency)
    return New("UIStroke", { Parent = parent, Color = accent(), Thickness = thickness or 1, Transparency = transparency or 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
end

local function Tween(obj, duration, props, style, direction)
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

for _, child in ipairs(Tab:GetChildren()) do child:Destroy() end

Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0
Tab.ScrollBarThickness = 0
Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

local root = New("Frame", { Parent = Tab, Size = UDim2.new(1, -10, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 })
New("UIPadding", { Parent = root, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) })
New("UIListLayout", { Parent = root, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })

-- ===== TOP BAR: Back + Search (trang trí thêm, giữ nguyên chức năng) =====
local topBar = New("Frame", { Parent = root, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 45), BackgroundTransparency = 1 })

local backBtn = New("TextButton", { Parent = topBar, Size = UDim2.fromOffset(45, 45), BackgroundColor3 = Color3.fromRGB(12, 13, 19), AutoButtonColor = false, Text = "" })
Corner(backBtn, 12)
local backStroke = Stroke(backBtn, 1, 0.4)
New("UIGradient", {
    Parent = backBtn,
    Rotation = 90,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 22, 32)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 11, 17))
    })
})
local backLabel = New("TextLabel", { Parent = backBtn, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "←", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = accent() })

backBtn.MouseEnter:Connect(function()
    Tween(backStroke, 0.15, {Transparency = 0.05, Thickness = 1.4})
    Tween(backBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(16, 18, 26)})
end)
backBtn.MouseLeave:Connect(function()
    Tween(backStroke, 0.15, {Transparency = 0.4, Thickness = 1})
    Tween(backBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(12, 13, 19)})
end)

local searchBox = New("Frame", { Parent = topBar, Position = UDim2.new(0, 55, 0, 0), Size = UDim2.new(1, -55, 1, 0), BackgroundColor3 = Color3.fromRGB(12, 13, 19) })
Corner(searchBox, 12)
local searchStroke = Stroke(searchBox, 1, 0.4)
New("UIGradient", {
    Parent = searchBox,
    Rotation = 90,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 22, 32)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 11, 17))
    })
})

New("TextLabel", { Parent = searchBox, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0, 20, 1, 0), BackgroundTransparency = 1, Text = "🔍", TextSize = 14 })
local searchInput = New("TextBox", { Parent = searchBox, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, ClearTextOnFocus = false, PlaceholderText = "search...", PlaceholderColor3 = Color3.fromRGB(100, 105, 120), Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left })

searchInput.Focused:Connect(function()
    Tween(searchStroke, 0.15, {Transparency = 0.05})
end)
searchInput:GetPropertyChangedSignal("Text"):Connect(function() end)
searchInput.FocusLost:Connect(function()
    Tween(searchStroke, 0.15, {Transparency = 0.4})
end)

-- ===== CONTENT FRAME (trang trí: gradient, glow góc, accent bar, icon) =====
local contentFrame = New("Frame", {
    Parent = root,
    LayoutOrder = 2,
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = Color3.fromRGB(9, 10, 15),
    BorderSizePixel = 0,
    ClipsDescendants = true
})
Corner(contentFrame, 16)
local contentStroke = Stroke(contentFrame, 1, 0.6)

New("UIGradient", {
    Parent = contentFrame,
    Rotation = 100,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 15, 23)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 9, 14))
    })
})

local contentGlow = New("Frame", {
    Parent = contentFrame,
    Position = UDim2.new(1, -90, 0, -70),
    Size = UDim2.fromOffset(160, 160),
    BackgroundColor3 = accent(),
    BackgroundTransparency = 0.92,
    BorderSizePixel = 0
})
Corner(contentGlow, 99)
New("UIGradient", {
    Parent = contentGlow,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
})

local contentGlow2 = New("Frame", {
    Parent = contentFrame,
    Position = UDim2.new(0, -50, 1, -40),
    Size = UDim2.fromOffset(110, 110),
    BackgroundColor3 = accent(),
    BackgroundTransparency = 0.95,
    BorderSizePixel = 0
})
Corner(contentGlow2, 99)
New("UIGradient", {
    Parent = contentGlow2,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.15),
        NumberSequenceKeypoint.new(1, 1)
    })
})

local contentInner = New("Frame", {
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    ZIndex = 2
})
New("UIPadding", {
    Parent = contentInner,
    PaddingTop = UDim.new(0, 16),
    PaddingBottom = UDim.new(0, 16),
    PaddingLeft = UDim.new(0, 16),
    PaddingRight = UDim.new(0, 16)
})

local headerRow = New("Frame", {
    Parent = contentInner,
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1
})

local accentDot = New("Frame", {
    Parent = headerRow,
    Position = UDim2.fromOffset(0, 11),
    Size = UDim2.fromOffset(4, 18),
    BackgroundColor3 = accent(),
    BorderSizePixel = 0
})
Corner(accentDot, 4)

New("TextLabel", {
    Parent = headerRow,
    Position = UDim2.fromOffset(16, 0),
    Size = UDim2.new(1, -16, 1, 0),
    BackgroundTransparency = 1,
    Text = "Shop Content Items & Upgrades",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(200, 205, 220),
    TextXAlignment = Enum.TextXAlignment.Left
})

local divider = New("Frame", {
    Parent = contentInner,
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = accent(),
    BackgroundTransparency = 0.85,
    BorderSizePixel = 0
})

-- Fix nút Back gọi hàm quay lại menu function chính
backBtn.Activated:Connect(function()
    if type(context.BackToMain) == "function" then
        context.BackToMain()
    elseif type(context.LoadFunction) == "function" then
        context.LoadFunction("function")
    elseif type(context.Navigate) == "function" then
        context.Navigate("Function")
    end
end)

task.spawn(function()
    while root.Parent do
        local a = accent()
        backStroke.Color = a
        backLabel.TextColor3 = a
        searchStroke.Color = a
        contentStroke.Color = a
        contentGlow.BackgroundColor3 = a
        contentGlow2.BackgroundColor3 = a
        accentDot.BackgroundColor3 = a
        divider.BackgroundColor3 = a
        task.wait(0.2)
    end
end)

return { Root = root }
