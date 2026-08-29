--[[
    farm.lua
    Module: Farm Hub (Farm / Fishing / Miss)
    Layout  : Left tab menu (smaller) + vertical divider + Right content (larger)
    Effects : Smooth vertical-line indicator switching tabs, search filter, no scrollbar
]]

local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab    = context.Tab
local Config = context.Config or {}

-- Sub-tab configuration (name + url source)
local SUB_TABS = {
    { Name = "Farm",    Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/farm.lua" },
    { Name = "Fishing", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/fishing.lua" },
    { Name = "Miss",    Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/missfarm.lua" },
}

-- =================== helpers ===================
local function accent()
    if Config.Rainbow or Config.RainbowMode then
        local hue = tick() % 5 / 5
        return Color3.fromHSV(hue, 1, 1)
    end
    return typeof(Config.ThemeColor) == "Color3" and Config.ThemeColor or Color3.fromRGB(0, 229, 255)
end

local function new(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function corner(p, r)
    return new("UICorner", { Parent = p, CornerRadius = UDim.new(0, r) })
end

local function stroke(p, t, tr)
    return new("UIStroke", { Parent = p, Color = accent(), Thickness = t or 1, Transparency = tr or 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
end

local function tween(obj, props, dur, style, dir)
    local info = TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- =================== clean parent tab ===================
for _, c in ipairs(Tab:GetChildren()) do c:Destroy() end
Tab.BackgroundTransparency = 1
Tab.BorderSizePixel       = 0
Tab.ScrollBarThickness    = 0
Tab.AutomaticCanvasSize   = Enum.AutomaticSize.Y

-- =================== root ===================
local root = new("Frame", {
    Parent          = Tab,
    Size            = UDim2.new(1, -10, 0, 0),
    AutomaticSize   = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
})
new("UIPadding", { Parent = root, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
new("UIListLayout", { Parent = root, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })

-- =================== top bar ===================
local topBar = new("Frame", { Parent = root, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1 })

local backBtn = new("TextButton", {
    Parent = topBar, Size = UDim2.fromOffset(50, 50),
    BackgroundColor3 = Color3.fromRGB(12, 13, 19), AutoButtonColor = false, Text = "",
})
corner(backBtn, 12)
local backStroke = stroke(backBtn, 1, 0.4)
local arrow = new("TextLabel", {
    Parent = backBtn, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    Text = "‹", Font = Enum.Font.GothamBold, TextSize = 26, TextColor3 = accent(),
})

local searchBox = new("Frame", {
    Parent = topBar, Position = UDim2.new(0, 60, 0, 0), Size = UDim2.new(1, -60, 1, 0),
    BackgroundColor3 = Color3.fromRGB(12, 13, 19),
})
corner(searchBox, 12)
local searchStroke = stroke(searchBox, 1, 0.4)

new("TextLabel", {
    Parent = searchBox, Position = UDim2.new(0, 16, 0, 0), Size = UDim2.new(0, 18, 1, 0),
    BackgroundTransparency = 1, Text = "⌕", Font = Enum.Font.GothamBold, TextSize = 16,
    TextColor3 = Color3.fromRGB(140, 145, 160), TextXAlignment = Enum.TextXAlignment.Left,
})
local searchInput = new("TextBox", {
    Parent = searchBox, Position = UDim2.new(0, 42, 0, 0), Size = UDim2.new(1, -52, 1, 0),
    BackgroundTransparency = 1, ClearTextOnFocus = false,
    PlaceholderText = "search tabs...", PlaceholderColor3 = Color3.fromRGB(100, 105, 120),
    Text = "", Font = Enum.Font.GothamMedium, TextSize = 13,
    TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left,
})

-- =================== main area (left tabs | right content) ===================
local mainArea = new("Frame", {
    Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 400),
    BackgroundTransparency = 1,
})

-- Left tab panel (smaller)
local leftPanel = new("Frame", {
    Parent = mainArea, Size = UDim2.new(0.28, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(12, 13, 19), BackgroundTransparency = 0.05,
    ClipsDescendants = true, BorderSizePixel = 0,
})
corner(leftPanel, 14)
local leftStroke = stroke(leftPanel, 1, 0.45)

local tabList = new("Frame", {
    Parent = leftPanel, Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1, BorderSizePixel = 0,
})
new("UIPadding", { Parent = tabList, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
new("UIListLayout", { Parent = tabList, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })

-- The vertical-line indicator (the animated focus marker)
local activeIndicator = new("Frame", {
    Parent = leftPanel, BackgroundColor3 = accent(), BorderSizePixel = 0, ZIndex = 10,
    Size = UDim2.new(0, 3, 0, 44), Position = UDim2.new(0, 4, 0, 12),
})
corner(activeIndicator, 2)

-- Vertical divider between panels
local divider = new("Frame", {
    Parent = mainArea, BackgroundColor3 = accent(), BorderSizePixel = 0,
    Position = UDim2.new(0.28, 4, 0.06, 0), Size = UDim2.new(0, 1, 0.88, 0),
    BackgroundTransparency = 0.78,
})

-- Right content panel (larger, no scrollbar)
local rightPanel = new("ScrollingFrame", {
    Parent = mainArea, Position = UDim2.new(0.28, 14, 0, 0), Size = UDim2.new(0.72, -14, 1, 0),
    BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.25,
    ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.Y,
    BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
})
corner(rightPanel, 14)
local rightStroke = stroke(rightPanel, 1, 0.45)
new("UIPadding", { Parent = rightPanel, PaddingTop = UDim.new(0, 18), PaddingBottom = UDim.new(0, 18), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20) })

local contentHolder = new("Frame", {
    Parent = rightPanel, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1, BorderSizePixel = 0,
})
new("UIListLayout", { Parent = contentHolder, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })

-- Default content placeholder
local function buildPlaceholder(tabData)
    for _, c in ipairs(contentHolder:GetChildren()) do c:Destroy() end
    local header = new("Frame", { Parent = contentHolder, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 })
    new("UIPadding", { Parent = header, PaddingBottom = UDim.new(0, 6) })
    new("TextLabel", {
        Parent = header, Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1,
        Text = tabData.Name, Font = Enum.Font.GothamBold, TextSize = 18,
        TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left,
    })
    new("TextLabel", {
        Parent = header, Position = UDim2.new(0, 0, 0, 26), Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
        Text = "Source: " .. tabData.Url, Font = Enum.Font.GothamMedium, TextSize = 10,
        TextColor3 = Color3.fromRGB(110, 115, 130), TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true, TextTruncate = Enum.TextTruncate.AtEnd,
    })
    new("TextLabel", {
        Parent = header, Position = UDim2.new(0, 0, 0, 52), Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
        Text = "Module content is provided by the loader.", Font = Enum.Font.GothamMedium, TextSize = 11,
        TextColor3 = Color3.fromRGB(160, 165, 180), TextXAlignment = Enum.TextXAlignment.Left,
    })
end

-- =================== tab buttons ===================
local tabButtons = {}
local activeIndex = 1
local TAB_HEIGHT       = 50
local TAB_PADDING      = 6
local LIST_TOP_PADDING = 10

for i, subTab in ipairs(SUB_TABS) do
    local btn = new("TextButton", {
        Parent = tabList, Size = UDim2.new(1, 0, 0, TAB_HEIGHT),
        BackgroundTransparency = 1, AutoButtonColor = false, Text = "", LayoutOrder = i,
    })
    corner(btn, 10)

    local indexLabel = new("TextLabel", {
        Parent = btn, Position = UDim2.new(0, 18, 0, 0), Size = UDim2.new(0, 28, 1, 0),
        BackgroundTransparency = 1, Text = string.format("%02d", i),
        Font = Enum.Font.GothamBold, TextSize = 11,
        TextColor3 = Color3.fromRGB(70, 75, 90), TextXAlignment = Enum.TextXAlignment.Left,
    })
    local label = new("TextLabel", {
        Parent = btn, Position = UDim2.new(0, 48, 0, 0), Size = UDim2.new(1, -72, 1, 0),
        BackgroundTransparency = 1, Text = subTab.Name,
        Font = Enum.Font.GothamSemibold, TextSize = 13,
        TextColor3 = Color3.fromRGB(140, 145, 160), TextXAlignment = Enum.TextXAlignment.Left,
    })
    local dot = new("Frame", {
        Parent = btn, Position = UDim2.new(1, -22, 0.5, -3), Size = UDim2.fromOffset(6, 6),
        BackgroundColor3 = Color3.fromRGB(45, 50, 65), BorderSizePixel = 0,
    })
    corner(dot, 3)

    tabButtons[i] = { Button = btn, IndexLabel = indexLabel, Label = label, Dot = dot, Data = subTab }
end

-- =================== switch tab ===================
local function setActive(index, instant)
    if index < 1 or index > #tabButtons then return end
    activeIndex = index

    for i, tab in ipairs(tabButtons) do
        if i == index then
            tween(tab.Label,      { TextColor3 = Color3.fromRGB(240, 242, 248) }, 0.18)
            tween(tab.IndexLabel, { TextColor3 = accent() },                       0.18)
            tween(tab.Dot,        { BackgroundColor3 = accent() },                 0.18)
        else
            tween(tab.Label,      { TextColor3 = Color3.fromRGB(140, 145, 160) }, 0.18)
            tween(tab.IndexLabel, { TextColor3 = Color3.fromRGB(70, 75, 90) },    0.18)
            tween(tab.Dot,        { BackgroundColor3 = Color3.fromRGB(45, 50, 65) }, 0.18)
        end
    end

    local targetY = LIST_TOP_PADDING + (index - 1) * (TAB_HEIGHT + TAB_PADDING) + 3
    if instant then
        activeIndicator.Position = UDim2.new(0, 4, 0, targetY)
    else
        tween(activeIndicator, { Position = UDim2.new(0, 4, 0, targetY) }, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    end

    if type(context.LoadSubTab) == "function" then
        pcall(context.LoadSubTab, SUB_TABS[index], contentHolder)
    elseif type(context.LoadContent) == "function" then
        pcall(context.LoadContent, SUB_TABS[index], contentHolder)
    else
        buildPlaceholder(SUB_TABS[index])
    end
end

for i, tab in ipairs(tabButtons) do
    tab.Button.Activated:Connect(function()
        setActive(i, false)
    end)
end

-- =================== search filter ===================
local function filterTabs(query)
    query = string.lower(query or "")
    for i, tab in ipairs(tabButtons) do
        local matches = query == "" or string.find(string.lower(tab.Data.Name), query, 1, true) ~= nil
        tab.Button.Visible = matches
    end
    if not tabButtons[activeIndex].Button.Visible then
        for i, tab in ipairs(tabButtons) do
            if tab.Button.Visible then setActive(i, true); return end
        end
    end
end

searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    filterTabs(searchInput.Text)
end)

-- =================== back button ===================
backBtn.Activated:Connect(function()
    if type(context.BackToMain) == "function" then
        pcall(context.BackToMain)
    elseif type(context.LoadFunction) == "function" then
        pcall(context.LoadFunction)
    end
end)

-- =================== live accent colour sync ===================
local conn
conn = RunService.RenderStepped:Connect(function()
    if not root.Parent then conn:Disconnect(); return end
    local a = accent()
    backStroke.Color = a
    searchStroke.Color = a
    leftStroke.Color = a
    rightStroke.Color = a
    divider.BackgroundColor3 = a
    arrow.TextColor3 = a
    activeIndicator.BackgroundColor3 = a
    local active = tabButtons[activeIndex]
    if active and active.Button.Visible then
        active.IndexLabel.TextColor3 = a
        active.Dot.BackgroundColor3  = a
    end
end)

-- =================== auto-load first tab ===================
setActive(1, true)

return { Root = root }
