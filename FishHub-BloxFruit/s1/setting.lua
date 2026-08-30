-- ============================================================
--  SETTING MODULE
--  Cấu trúc: Top bar (back + search) đồng bộ với các module khác
--  Có hiệu ứng accent, hover, animation mượt — không dùng icon xấu
-- ============================================================

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab    = context.Tab
local Config = context.Config or {}

-- ============================================================
-- UTILITIES
-- ============================================================
local function accent()
    if Config.Rainbow or Config.RainbowMode then
        local hue = tick() % 5 / 5
        return Color3.fromHSV(hue, 1, 1)
    end
    return typeof(Config.ThemeColor) == "Color3" and Config.ThemeColor or Color3.fromRGB(0, 229, 255)
end

local function New(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function Corner(p, r) return New("UICorner", { Parent = p, CornerRadius = UDim.new(0, r) }) end
local function Pad(p, t, b, l, r) return New("UIPadding", { Parent = p, PaddingTop = UDim.new(0,t), PaddingBottom = UDim.new(0,b), PaddingLeft = UDim.new(0,l), PaddingRight = UDim.new(0,r) }) end

local function Stroke(p, th, tr)
    return New("UIStroke", {
        Parent = p, Color = accent(), Thickness = th or 1,
        Transparency = tr or 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function tween(obj, props, dur, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(dur or 0.28, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

-- ============================================================
-- CLEAR & ROOT
-- ============================================================
for _, child in ipairs(Tab:GetChildren()) do child:Destroy() end
Tab.BackgroundTransparency = 1
Tab.BorderSizePixel        = 0
Tab.ScrollBarThickness     = 0
Tab.AutomaticCanvasSize    = Enum.AutomaticSize.Y

local root = New("Frame", {
    Parent = Tab, Size = UDim2.new(1, -10, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
})
Pad(root, 8, 12, 8, 8)
New("UIListLayout", { Parent = root, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })

-- ============================================================
-- TOP BAR (Back + Search) — đồng bộ 100% với các module khác
-- ============================================================
local topBar = New("Frame", { Parent = root, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1 })

local backBtn = New("TextButton", {
    Parent = topBar, Size = UDim2.fromOffset(40, 40),
    BackgroundColor3 = Color3.fromRGB(14, 16, 24), AutoButtonColor = false, Text = "",
})
Corner(backBtn, 10)
local backStroke = Stroke(backBtn, 1, 0.4)
local backArrow = New("TextLabel", {
    Parent = backBtn, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    Text = "‹", Font = Enum.Font.GothamBold, TextSize = 26, TextColor3 = accent(),
})

backBtn.MouseEnter:Connect(function() tween(backBtn, {BackgroundColor3 = Color3.fromRGB(24, 28, 42)}, 0.2) end)
backBtn.MouseLeave:Connect(function() tween(backBtn, {BackgroundColor3 = Color3.fromRGB(14, 16, 24)}, 0.2) end)
backBtn.Activated:Connect(function()
    if type(context.BackToMain) == "function" then
        context.BackToMain()
    elseif type(context.LoadFunction) == "function" then
        context.LoadFunction()
    end
end)

local searchBox = New("Frame", {
    Parent = topBar, Position = UDim2.new(0, 50, 0, 0),
    Size = UDim2.new(1, -50, 1, 0), BackgroundColor3 = Color3.fromRGB(14, 16, 24),
})
Corner(searchBox, 10)
local searchStroke = Stroke(searchBox, 1, 0.4)

-- Search icon (kính lúp vector-style — đồng bộ với các module khác)
New("TextLabel", {
    Parent = searchBox, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.fromOffset(22, 40),
    BackgroundTransparency = 1, Text = "⌕", Font = Enum.Font.GothamBold, TextSize = 18,
    TextColor3 = Color3.fromRGB(140, 150, 175),
})

local searchInput = New("TextBox", {
    Parent = searchBox, Position = UDim2.new(0, 36, 0, 0), Size = UDim2.new(1, -46, 1, 0),
    BackgroundTransparency = 1, ClearTextOnFocus = false,
    PlaceholderText = "Search setting...", PlaceholderColor3 = Color3.fromRGB(95, 100, 120),
    Text = "", Font = Enum.Font.GothamMedium, TextSize = 12,
    TextColor3 = Color3.fromRGB(230, 235, 245), TextXAlignment = Enum.TextXAlignment.Left,
})

-- ============================================================
-- CONTENT PLACEHOLDER (panel trống đồng bộ giao diện)
-- ============================================================
local placeholder = New("Frame", {
    Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 80),
    BackgroundColor3 = Color3.fromRGB(11, 12, 18), BackgroundTransparency = 0.3,
})
Corner(placeholder, 12)
Stroke(placeholder, 1, 0.6)
New("TextLabel", {
    Parent = placeholder, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    Text = "Settings", Font = Enum.Font.GothamBold, TextSize = 14,
    TextColor3 = Color3.fromRGB(180, 190, 210),
})

-- ============================================================
-- LIVE ACCENT
-- ============================================================
local conn
conn = RunService.RenderStepped:Connect(function()
    if not root.Parent then conn:Disconnect() return end
    local a = accent()
    backStroke.Color   = a
    searchStroke.Color = a
    backArrow.TextColor3 = a
end)

return { Root = root }
