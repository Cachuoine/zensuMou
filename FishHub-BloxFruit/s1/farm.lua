--[[
    farm.lua
    FishHub-BloxFruit | Farm Module
    Left/right split layout with animated tab menu and URL-loaded content.
]]

local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local RunService         = game:GetService("RunService")
local HttpService        = game:GetService("HttpService")

-- ============================================================
-- CONTEXT GUARD
-- ============================================================
local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab    = context.Tab
local Config = context.Config or {}

-- ============================================================
-- CONFIG
-- ============================================================
local TABS = {
    {
        key     = "farm",
        title   = "Farm",
        subtitle= "Auto-farm mobs & quests",
        icon    = "🌾",
        url     = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/farm.lua",
        accent  = Color3.fromRGB(120, 230, 160),
    },
    {
        key     = "fishing",
        title   = "Fishing",
        subtitle= "Auto-fish & catch events",
        icon    = "🎣",
        url     = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/fishing.lua",
        accent  = Color3.fromRGB(80, 200, 255),
    },
    {
        key     = "miss",
        title   = "Misc",
        subtitle= "Other farm tools",
        icon    = "✨",
        url     = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/missfarm.lua",
        accent  = Color3.fromRGB(255, 170, 60),
    },
}

-- ============================================================
-- THEME
-- ============================================================
local function accent()
    if Config.Rainbow or Config.RainbowMode then
        local hue = tick() % 5 / 5
        return Color3.fromHSV(hue, 1, 1)
    end
    return typeof(Config.ThemeColor) == "Color3" and Config.ThemeColor or Color3.fromRGB(0, 229, 255)
end

local C = {
    bgDeep   = Color3.fromRGB(7, 8, 12),
    bgPanel  = Color3.fromRGB(13, 14, 20),
    bgItem   = Color3.fromRGB(18, 20, 28),
    bgItemH  = Color3.fromRGB(24, 27, 38),
    textMain = Color3.fromRGB(240, 242, 248),
    textSub  = Color3.fromRGB(140, 145, 165),
    textDim  = Color3.fromRGB(90, 95, 115),
    divider  = Color3.fromRGB(35, 38, 52),
    white    = Color3.fromRGB(255, 255, 255),
    black    = Color3.fromRGB(0, 0, 0),
}

-- ============================================================
-- HELPERS
-- ============================================================
local function New(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function Corner(parent, radius)
    return New("UICorner", { Parent = parent, CornerRadius = UDim.new(0, radius) })
end

local function Padding(parent, t, b, l, r)
    return New("UIPadding", { Parent = parent, PaddingTop = UDim.new(0, t), PaddingBottom = UDim.new(0, b), PaddingLeft = UDim.new(0, l), PaddingRight = UDim.new(0, r) })
end

local function Stroke(parent, color, thickness, transparency)
    return New("UIStroke", {
        Parent = parent,
        Color = color or accent(),
        Thickness = thickness or 1,
        Transparency = transparency or 0.4,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function Gradient(parent, c1, c2, rotation)
    return New("UIGradient", { Parent = parent, Color = ColorSequence.new(c1, c2), Rotation = rotation or 90 })
end

local function Tween(obj, t, props, style, dir)
    local info = TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

-- ============================================================
-- RESET TAB
-- ============================================================
for _, child in ipairs(Tab:GetChildren()) do child:Destroy() end
Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0
Tab.ScrollBarThickness = 0
Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- ============================================================
-- ROOT
-- ============================================================
local root = New("Frame", { Parent = Tab, Size = UDim2.new(1, -10, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 })
Padding(root, 8, 12, 5, 5)
New("UIListLayout", { Parent = root, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })

-- ============================================================
-- TOP BAR (BACK + SEARCH)
-- ============================================================
local topBar = New("Frame", { Parent = root, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1 })

local backBtn = New("TextButton", { Parent = topBar, Size = UDim2.fromOffset(42, 42), BackgroundColor3 = C.bgPanel, AutoButtonColor = false, Text = "" })
Corner(backBtn, 10)
local backStroke = Stroke(backBtn, accent(), 1, 0.4)
local arrow = New("TextLabel", { Parent = backBtn, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "‹", Font = Enum.Font.GothamBlack, TextSize = 26, TextColor3 = accent() })
Gradient(arrow, accent(), C.white, 90)

local searchBox = New("Frame", { Parent = topBar, Position = UDim2.new(0, 52, 0, 0), Size = UDim2.new(1, -52, 1, 0), BackgroundColor3 = C.bgPanel })
Corner(searchBox, 10)
Stroke(searchBox, accent(), 1, 0.4)

local searchIcon = New("TextLabel", { Parent = searchBox, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.fromOffset(20, 42), BackgroundTransparency = 1, Text = "⌕", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = accent() })
Gradient(searchIcon, accent(), C.white, 90)

local searchInput = New("TextBox", {
    Parent = searchBox,
    Position = UDim2.new(0, 38, 0, 0),
    Size = UDim2.new(1, -50, 1, 0),
    BackgroundTransparency = 1,
    ClearTextOnFocus = false,
    PlaceholderText = "Search in farm...",
    PlaceholderColor3 = C.textDim,
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 13,
    TextColor3 = C.textMain,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- ============================================================
-- MAIN AREA
-- ============================================================
local mainArea = New("Frame", { Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 360), BackgroundTransparency = 1 })

local leftPanel = New("Frame", { Parent = mainArea, Size = UDim2.new(0.32, -4, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = C.bgPanel, BackgroundTransparency = 0.3 })
Corner(leftPanel, 12)
Stroke(leftPanel, accent(), 1, 0.55)
Padding(leftPanel, 8, 8, 6, 6)
local leftList = New("ScrollingFrame", { Parent = leftPanel, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = accent(), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y })
New("UIListLayout", { Parent = leftList, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })

local divider = New("Frame", { Parent = mainArea, Size = UDim2.new(0, 1, 1, -16), Position = UDim2.new(0.32, 0, 0, 8), BackgroundColor3 = C.divider, BorderSizePixel = 0 })
Gradient(divider, Color3.fromRGB(60, 65, 85), Color3.fromRGB(20, 22, 32), 90)

local rightPanel = New("Frame", { Parent = mainArea, Size = UDim2.new(0.68, -5, 1, 0), Position = UDim2.new(0.32, 4, 0, 0), BackgroundColor3 = C.bgPanel, BackgroundTransparency = 0.4 })
Corner(rightPanel, 12)
Stroke(rightPanel, accent(), 1, 0.55)
Padding(rightPanel, 14, 14, 14, 14)

local rHeader = New("Frame", { Parent = rightPanel, Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1, LayoutOrder = 1 })
local rIcon = New("TextLabel", { Parent = rHeader, Size = UDim2.fromOffset(48, 48), Position = UDim2.new(0, 0, 0.5, -24), BackgroundColor3 = C.bgItem, BackgroundTransparency = 0.2, Text = "", Font = Enum.Font.GothamBold, TextSize = 22, TextColor3 = C.white })
Corner(rIcon, 12)
Stroke(rIcon, accent(), 1, 0.3)

local rTitle = New("TextLabel", { Parent = rHeader, Position = UDim2.new(0, 58, 0, 4), Size = UDim2.new(1, -120, 0, 24), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = C.textMain, TextXAlignment = Enum.TextXAlignment.Left, Text = "Farm" })
local rSub   = New("TextLabel", { Parent = rHeader, Position = UDim2.new(0, 58, 0, 28), Size = UDim2.new(1, -120, 0, 18), BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.textSub, TextXAlignment = Enum.TextXAlignment.Left, Text = "Pick a category" })

local rUrlLabel = New("TextLabel", {
    Parent = rHeader,
    Position = UDim2.new(1, -160, 0, 16),
    Size = UDim2.fromOffset(155, 24),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamMedium,
    TextSize = 10,
    TextColor3 = C.textDim,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextTruncate = Enum.TextTruncate.AtEnd,
    Text = "",
})

local rBody = New("ScrollingFrame", { Parent = rightPanel, Size = UDim2.new(1, 0, 1, -70), Position = UDim2.new(0, 0, 0, 64), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = accent(), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y })
New("UIListLayout", { Parent = rBody, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })
Padding(rBody, 4, 8, 2, 6)

local rStatus = New("TextLabel", { Parent = rBody, LayoutOrder = 0, Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.textSub, TextXAlignment = Enum.TextXAlignment.Left, Text = "Loading..." })

local rContent = New("TextLabel", {
    Parent = rBody,
    LayoutOrder = 1,
    Size = UDim2.new(1, -10, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Font = Enum.Font.Code,
    TextSize = 12,
    TextColor3 = C.textMain,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    RichText = false,
    Text = "",
})

-- ============================================================
-- BUILD TABS
-- ============================================================
local tabButtons  = {}
local activeIndex = 1

local function buildTabCard(data, order)
    local card = New("TextButton", {
        Parent = leftList,
        LayoutOrder = order,
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = C.bgItem,
        AutoButtonColor = false,
        Text = "",
        ClipsDescendants = true,
    })
    Corner(card, 10)
    Stroke(card, accent(), 1, 0.75)

    local vLine = New("Frame", {
        Parent = card,
        Size = UDim2.new(0, 3, 0.6, 0),
        Position = UDim2.new(0, 4, 0.2, 0),
        BackgroundColor3 = data.accent,
        BackgroundTransparency = 1,
    })
    Corner(vLine, 2)
    Gradient(vLine, data.accent, Color3.fromRGB(255, 255, 255), 90)
    vLine.Size = UDim2.new(0, 3, 0, 0)

    local iconBubble = New("Frame", { Parent = card, Size = UDim2.fromOffset(36, 36), Position = UDim2.new(0, 14, 0.5, -18), BackgroundColor3 = Color3.fromRGB(8, 9, 14) })
    Corner(iconBubble, 10)
    Stroke(iconBubble, data.accent, 1, 0.5)

    local iconLabel = New("TextLabel", { Parent = iconBubble, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = data.icon, Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = C.white })
    Gradient(iconLabel, C.white, data.accent, 180)

    local title = New("TextLabel", { Parent = card, Position = UDim2.new(0, 58, 0, 8), Size = UDim2.new(1, -66, 0, 20), BackgroundTransparency = 1, Text = data.title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.textMain, TextXAlignment = Enum.TextXAlignment.Left })
    local sub   = New("TextLabel", { Parent = card, Position = UDim2.new(0, 58, 0, 28), Size = UDim2.new(1, -66, 0, 16), BackgroundTransparency = 1, Text = data.subtitle, Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = C.textSub, TextXAlignment = Enum.TextXAlignment.Left })

    card.MouseEnter:Connect(function()
        if activeIndex ~= order then
            Tween(card, 0.18, { BackgroundColor3 = C.bgItemH })
            Tween(iconBubble, 0.18, { BackgroundColor3 = data.accent })
            Tween(iconLabel, 0.18, { TextColor3 = C.white })
        end
    end)
    card.MouseLeave:Connect(function()
        if activeIndex ~= order then
            Tween(card, 0.18, { BackgroundColor3 = C.bgItem })
            Tween(iconBubble, 0.18, { BackgroundColor3 = Color3.fromRGB(8, 9, 14) })
        end
    end)

    return card, vLine, iconBubble, iconLabel, title, sub
end

for i, data in ipairs(TABS) do
    local card, vLine, iconBubble, iconLabel, title, sub = buildTabCard(data, i)
    tabButtons[i] = { card = card, vLine = vLine, data = data, iconBubble = iconBubble, iconLabel = iconLabel, title = title, sub = sub }
end

-- ============================================================
-- TAB SWITCH + ANIMATION
-- ============================================================
local function clearContent()
    for _, c in ipairs(rBody:GetChildren()) do
        if c:IsA("TextLabel") then c.Text = "" end
    end
    rStatus.Text = "Loading..."
    rContent.Text = ""
end

local function applyFilter(raw)
    local q = (searchInput.Text or ""):lower()
    if q == "" then return raw end
    local lines = string.split(raw, "\n")
    local out = {}
    for _, ln in ipairs(lines) do
        if ln:lower():find(q, 1, true) then table.insert(out, ln) end
    end
    if #out == 0 then return "-- No matches for \"" .. searchInput.Text .. "\"" end
    return table.concat(out, "\n")
end

local function loadTabContent(data)
    clearContent()
    rStatus.Text = "Loading " .. data.title .. "..."
    rStatus.TextColor3 = data.accent

    local ok, body = pcall(function()
        return game:HttpGet(data.url, true)
    end)

    if not ok or type(body) ~= "string" then
        rStatus.Text = "Failed to load content"
        rStatus.TextColor3 = Color3.fromRGB(255, 90, 110)
        rContent.Text = "-- Could not fetch: " .. tostring(data.url) .. "\n-- Error: " .. tostring(body)
        rContent.TextColor3 = C.textSub
        return
    end

    rStatus.Text = "Loaded  " .. data.title
    rStatus.TextColor3 = Color3.fromRGB(120, 230, 160)
    rContent.Text = applyFilter(body)
    rContent.TextColor3 = C.textMain
end

local function setActive(idx)
    if idx == activeIndex then return end
    local prev = tabButtons[activeIndex]
    local curr = tabButtons[idx]
    if not curr then return end

    if prev then
        Tween(prev.vLine, 0.18, { Size = UDim2.new(0, 3, 0, 0), BackgroundTransparency = 1 })
        Tween(prev.card, 0.18, { BackgroundColor3 = C.bgItem })
        Tween(prev.iconBubble, 0.18, { BackgroundColor3 = Color3.fromRGB(8, 9, 14) })
        Tween(prev.sub, 0.18, { TextColor3 = C.textSub })
    end

    curr.vLine.BackgroundTransparency = 0
    Tween(curr.vLine, 0.22, { Size = UDim2.new(0, 3, 0.6, 0) })
    Tween(curr.card, 0.22, { BackgroundColor3 = C.bgItemH })
    Tween(curr.iconBubble, 0.22, { BackgroundColor3 = curr.data.accent })
    Tween(curr.sub, 0.22, { TextColor3 = C.white })

    rIcon.Text = curr.data.icon
    rIcon.BackgroundColor3 = curr.data.accent
    rTitle.Text = curr.data.title
    rSub.Text = curr.data.subtitle
    rUrlLabel.Text = curr.data.url

    rContent.Position = UDim2.new(0, -8, 0, 0)
    rContent.TextTransparency = 0.4
    Tween(rContent, 0.25, { Position = UDim2.new(0, 0, 0, 0), TextTransparency = 0 })

    loadTabContent(curr.data)
    activeIndex = idx
end

for i, t in ipairs(tabButtons) do
    t.card.Activated:Connect(function() setActive(i) end)
end

-- ============================================================
-- SEARCH
-- ============================================================
searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local data = tabButtons[activeIndex] and tabButtons[activeIndex].data
    if data then
        rStatus.Text = "Filtering..."
        rStatus.TextColor3 = data.accent
        local ok, body = pcall(function() return game:HttpGet(data.url, true) end)
        if ok then
            rStatus.Text = "Filtered  " .. data.title
            rStatus.TextColor3 = Color3.fromRGB(120, 230, 160)
            rContent.Text = applyFilter(body)
        end
    end
end)

-- ============================================================
-- BACK
-- ============================================================
backBtn.Activated:Connect(function()
    Tween(backBtn, 0.08, { BackgroundColor3 = Color3.fromRGB(28, 32, 46) })
    task.delay(0.08, function() Tween(backBtn, 0.12, { BackgroundColor3 = C.bgPanel }) end)
    if type(context.BackToMain) == "function" then
        context.BackToMain()
    elseif type(context.LoadFunction) == "function" then
        context.LoadFunction()
    end
end)

-- ============================================================
-- INIT
-- ============================================================
setActive(1)

local connection
connection = RunService.RenderStepped:Connect(function()
    if not root.Parent then connection:Disconnect(); return end
    local a = accent()
    backStroke.Color = a
    local sb = searchBox:FindFirstChildWhichIsA("UIStroke")
    if sb then sb.Color = a end
    for i, t in ipairs(tabButtons) do
        if i ~= activeIndex then
            local s = t.card:FindFirstChildWhichIsA("UIStroke")
            if s then s.Color = a end
            s = t.iconBubble:FindFirstChildWhichIsA("UIStroke")
            if s then s.Color = t.data.accent end
        end
    end
end)

return { Root = root }
