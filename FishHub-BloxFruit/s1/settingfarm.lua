--[[
    settingfarm.lua
    FishHub-BloxFruit | Setting Farm Module
    v2 — bugfixes applied
]]

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab    = context.Tab
local Config = context.Config or {}

-- ============================================================
-- CONFIG
-- ============================================================
local TABS = {
    { key="settingfarm", title="Setting Farm",     subtitle="Configure farm behaviour", icon="⚙",  url="https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/settingfarm/misssettingfarm.lua", accent=Color3.fromRGB(255, 170, 60) },
    { key="holdselect",  title="Hold & Select Skill", subtitle="Keybinds & skill slots", icon="🎯", url="https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/settingfarm/hold%26selectskill.lua", accent=Color3.fromRGB(80, 220, 200) },
}

local TRANS = tonumber(Config.TransitionTime)
if TRANS == nil then TRANS = 0.12 end
local function dur(t) return (TRANS > 0) and t or 0 end

-- ============================================================
-- THEME
-- ============================================================
local function accent()
    if Config.Rainbow or Config.RainbowMode then
        local hue = (tick() * 0.18) % 1
        return Color3.fromHSV(hue, 1, 1)
    end
    return typeof(Config.ThemeColor) == "Color3" and Config.ThemeColor or Color3.fromRGB(0, 229, 255)
end

local C = {
    bgPanel  = Color3.fromRGB(13, 14, 20),
    bgItem   = Color3.fromRGB(18, 20, 28),
    bgItemH  = Color3.fromRGB(26, 29, 42),
    textMain = Color3.fromRGB(240, 242, 248),
    textSub  = Color3.fromRGB(140, 145, 165),
    textDim  = Color3.fromRGB(90, 95, 115),
    divider  = Color3.fromRGB(35, 38, 52),
    white    = Color3.fromRGB(255, 255, 255),
}

-- ============================================================
-- HELPERS
-- ============================================================
local function New(c, p) local o = Instance.new(c); for k, v in pairs(p or {}) do o[k] = v end; return o end
local function Corner(p, r) return New("UICorner", { Parent = p, CornerRadius = UDim.new(0, r) }) end
local function Padding(p, t, b, l, r) return New("UIPadding", { Parent = p, PaddingTop = UDim.new(0, t), PaddingBottom = UDim.new(0, b), PaddingLeft = UDim.new(0, l), PaddingRight = UDim.new(0, r) }) end
local function Stroke(p, col, th, tr) return New("UIStroke", { Parent = p, Color = col, Thickness = th or 1, Transparency = tr or 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }) end
local function Grad(p, c1, c2, rot) return New("UIGradient", { Parent = p, Color = ColorSequence.new(c1, c2), Rotation = rot or 90 }) end
local function Tween(obj, t, props)
    if t <= 0 then for k, v in pairs(props) do obj[k] = v end; return end
    local tw = TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), props)
    tw:Play(); return tw
end

-- ============================================================
-- RESET
-- ============================================================
for _, ch in ipairs(Tab:GetChildren()) do ch:Destroy() end
Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0
Tab.ScrollBarThickness = 0
Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
Tab.AutomaticSize = Enum.AutomaticSize.Y

local root = New("Frame", { Parent = Tab, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 })
Padding(root, 8, 10, 8, 8)
New("UIListLayout", { Parent = root, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })

-- ============================================================
-- TOP BAR
-- ============================================================
local topBar = New("Frame", { Parent = root, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1 })

local backBtn = New("TextButton", { Parent = topBar, Size = UDim2.fromOffset(38, 38), BackgroundColor3 = C.bgPanel, AutoButtonColor = false, Text = "" })
Corner(backBtn, 9)
local backStroke = Stroke(backBtn, accent(), 1, 0.4)
local ba1 = New("Frame", { Parent = backBtn, Size = UDim2.fromOffset(11, 1.6), Position = UDim2.new(0.5, -3, 0.5, -4), Rotation = 45,  BackgroundColor3 = accent(), BorderSizePixel = 0 })
local ba2 = New("Frame", { Parent = backBtn, Size = UDim2.fromOffset(11, 1.6), Position = UDim2.new(0.5, -3, 0.5, 2),  Rotation = -45, BackgroundColor3 = accent(), BorderSizePixel = 0 })

local searchBox = New("Frame", { Parent = topBar, Position = UDim2.new(0, 46, 0, 0), Size = UDim2.new(1, -46, 1, 0), BackgroundColor3 = C.bgPanel, ClipsDescendants = true })
Corner(searchBox, 9)
local sStroke = Stroke(searchBox, accent(), 1, 0.4)
local sIconWrap = New("Frame", { Parent = searchBox, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.fromOffset(20, 38), BackgroundTransparency = 1 })
local sLens = New("Frame", { Parent = sIconWrap, Size = UDim2.fromOffset(10, 10), Position = UDim2.new(0, 2, 0, 11), BackgroundTransparency = 1, BorderSizePixel = 0 })
Stroke(sLens, accent(), 1.4, 0.15)
local sHandle = New("Frame", { Parent = sIconWrap, Size = UDim2.fromOffset(1.5, 5), Position = UDim2.new(0, 13, 0, 21), BackgroundColor3 = accent(), BorderSizePixel = 0, Rotation = 45 })

local searchInput = New("TextBox", {
    Parent = searchBox, Position = UDim2.new(0, 36, 0, 0), Size = UDim2.new(1, -44, 1, 0),
    BackgroundTransparency = 1, ClearTextOnFocus = false,
    PlaceholderText = "search...", PlaceholderColor3 = C.textDim, Text = "",
    Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.textMain, TextXAlignment = Enum.TextXAlignment.Left,
})

-- ============================================================
-- MAIN AREA
-- ============================================================
local mainArea = New("Frame", { Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 })

local GAP, LWPCT = 6, 0.34

local leftPanel = New("Frame", { Parent = mainArea, Size = UDim2.new(LWPCT, -GAP/2, 0, 0), Position = UDim2.new(0, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.bgPanel, BackgroundTransparency = 0.25, ClipsDescendants = true })
Corner(leftPanel, 10); Stroke(leftPanel, accent(), 1, 0.55); Padding(leftPanel, 6, 6, 6, 6)
New("UIListLayout", { Parent = leftPanel, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) })

local divider = New("Frame", { Parent = mainArea, Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(LWPCT, -GAP/2, 0, 6), BackgroundColor3 = C.divider, BorderSizePixel = 0 })
Grad(divider, Color3.fromRGB(60, 65, 85), Color3.fromRGB(20, 22, 32), 90)

local rightPanel = New("Frame", { Parent = mainArea, Size = UDim2.new(1 - LWPCT, -GAP/2, 0, 0), Position = UDim2.new(LWPCT, GAP/2, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.bgPanel, BackgroundTransparency = 0.35, ClipsDescendants = true })
Corner(rightPanel, 10); Stroke(rightPanel, accent(), 1, 0.55); Padding(rightPanel, 12, 12, 14, 14)
New("UIListLayout", { Parent = rightPanel, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })

local rHeader = New("Frame", { Parent = rightPanel, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1 })
local rIcon = New("Frame", { Parent = rHeader, Size = UDim2.fromOffset(42, 42), Position = UDim2.new(0, 0, 0.5, -21), BackgroundColor3 = C.bgItem })
Corner(rIcon, 10); Stroke(rIcon, accent(), 1, 0.3)
local rIconLabel = New("TextLabel", { Parent = rIcon, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = C.white })

local rTitle = New("TextLabel", { Parent = rHeader, Position = UDim2.new(0, 52, 0, 6),  Size = UDim2.new(1, -120, 0, 22), BackgroundTransparency = 1, Font = Enum.Font.GothamBold,   TextSize = 15, TextColor3 = C.textMain, TextXAlignment = Enum.TextXAlignment.Left, Text = "Setting Farm" })
local rSub   = New("TextLabel", { Parent = rHeader, Position = UDim2.new(0, 52, 0, 28), Size = UDim2.new(1, -120, 0, 16), BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.textSub,  TextXAlignment = Enum.TextXAlignment.Left, Text = "Pick a category" })
local rUrlLabel = New("TextLabel", { Parent = rHeader, Position = UDim2.new(1, -150, 0, 16), Size = UDim2.fromOffset(145, 20), BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = C.textDim, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, Text = "" })

local rStatus = New("TextLabel", { Parent = rightPanel, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.textSub, TextXAlignment = Enum.TextXAlignment.Left, Text = "Loading..." })

local rContent = New("TextLabel", {
    Parent = rightPanel, LayoutOrder = 3, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1, Font = Enum.Font.Code, TextSize = 12, TextColor3 = C.textMain,
    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true, RichText = false, Text = "",
})

-- ============================================================
-- TABS
-- ============================================================
local tabButtons, activeIndex, requestId = {}, 1, 0

local function buildTabCard(data, order)
    local card = New("TextButton", { Parent = leftPanel, LayoutOrder = order, Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = C.bgItem, AutoButtonColor = false, Text = "", ClipsDescendants = true })
    Corner(card, 9)
    local cardStroke = Stroke(card, accent(), 1, 0.7)

    local vLine = New("Frame", { Parent = card, Size = UDim2.new(0, 3, 0, 0), Position = UDim2.new(0, 4, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = data.accent, BackgroundTransparency = 1, BorderSizePixel = 0 })
    Corner(vLine, 2); Grad(vLine, data.accent, C.white, 90)

    local iconBubble = New("Frame", { Parent = card, Size = UDim2.fromOffset(32, 32), Position = UDim2.new(0, 12, 0.5, -16), BackgroundColor3 = Color3.fromRGB(8, 9, 14) })
    Corner(iconBubble, 9)
    local ibStroke = Stroke(iconBubble, data.accent, 1, 0.4)
    local iconLabel = New("TextLabel", { Parent = iconBubble, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = data.icon, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = C.white })

    local title = New("TextLabel", { Parent = card, Position = UDim2.new(0, 52, 0, 6),  Size = UDim2.new(1, -60, 0, 18), BackgroundTransparency = 1, Text = data.title,    Font = Enum.Font.GothamBold,   TextSize = 12, TextColor3 = C.textMain, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd })
    local sub   = New("TextLabel", { Parent = card, Position = UDim2.new(0, 52, 0, 24), Size = UDim2.new(1, -60, 0, 14), BackgroundTransparency = 1, Text = data.subtitle, Font = Enum.Font.GothamMedium, TextSize = 9,  TextColor3 = C.textSub,  TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd })

    card.MouseEnter:Connect(function()
        if activeIndex ~= order then Tween(card, dur(0.08), { BackgroundColor3 = C.bgItemH }); Tween(iconBubble, dur(0.08), { BackgroundColor3 = data.accent }) end
    end)
    card.MouseLeave:Connect(function()
        if activeIndex ~= order then Tween(card, dur(0.08), { BackgroundColor3 = C.bgItem }); Tween(iconBubble, dur(0.08), { BackgroundColor3 = Color3.fromRGB(8, 9, 14) }) end
    end)

    return { card = card, vLine = vLine, iconBubble = iconBubble, iconLabel = iconLabel, cardStroke = cardStroke, ibStroke = ibStroke, data = data, title = title, sub = sub }
end

for i, d in ipairs(TABS) do tabButtons[i] = buildTabCard(d, i) end

-- ============================================================
-- CONTENT
-- ============================================================
local function applyFilter(raw)
    local q = (searchInput.Text or ""):lower()
    if q == "" then return raw end
    local lines = string.split(raw, "\n"); local out = {}; local n = 0
    for _, ln in ipairs(lines) do if ln:lower():find(q, 1, true) then out[#out+1] = ln; n += 1 end end
    if n == 0 then return "-- No matches for \"" .. searchInput.Text .. "\"" end
    return table.concat(out, "\n")
end

local function loadTabContent(data)
    requestId += 1; local myReq = requestId
    rStatus.Text = "Loading " .. data.title .. "..."; rStatus.TextColor3 = data.accent; rContent.Text = ""
    task.spawn(function()
        local ok, body = pcall(function() return game:HttpGet(data.url, true) end)
        if myReq ~= requestId then return end
        if not ok or type(body) ~= "string" then
            rStatus.Text = "Failed to load content"; rStatus.TextColor3 = Color3.fromRGB(255, 90, 110)
            rContent.Text = "-- Could not fetch: " .. tostring(data.url) .. "\n-- Error: " .. tostring(body); rContent.TextColor3 = C.textSub
        else
            rStatus.Text = "Loaded  " .. data.title; rStatus.TextColor3 = Color3.fromRGB(120, 230, 160)
            rContent.Text = applyFilter(body); rContent.TextColor3 = C.textMain
        end
    end)
end

local function setActive(idx)
    local prev = tabButtons[activeIndex]
    local curr = tabButtons[idx]
    if not curr then return end
    if prev == curr then loadTabContent(curr.data); return end

    if prev then
        Tween(prev.vLine,     dur(0.12), { Size = UDim2.new(0, 3, 0, 0),   BackgroundTransparency = 1 })
        Tween(prev.card,      dur(0.10), { BackgroundColor3 = C.bgItem })
        Tween(prev.iconBubble, dur(0.10), { BackgroundColor3 = Color3.fromRGB(8, 9, 14) })
        Tween(prev.sub,       dur(0.10), { TextColor3 = C.textSub })
        prev.cardStroke.Transparency = 0.7
    end

    curr.vLine.BackgroundTransparency = 0
    Tween(curr.vLine,      dur(0.12), { Size = UDim2.new(0, 3, 0.6, 0) })
    Tween(curr.card,        dur(0.10), { BackgroundColor3 = C.bgItemH })
    Tween(curr.iconBubble,  dur(0.10), { BackgroundColor3 = curr.data.accent })
    Tween(curr.sub,         dur(0.10), { TextColor3 = C.white })
    curr.cardStroke.Transparency = 0.3

    rIconLabel.Text = curr.data.icon; rIcon.BackgroundColor3 = curr.data.accent
    rTitle.Text = curr.data.title; rSub.Text = curr.data.subtitle; rUrlLabel.Text = curr.data.url

    loadTabContent(curr.data); activeIndex = idx
end

for i, t in ipairs(tabButtons) do t.card.Activated:Connect(function() setActive(i) end) end

searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local data = tabButtons[activeIndex] and tabButtons[activeIndex].data
    if not data then return end
    requestId += 1; local myReq = requestId
    rStatus.Text = "Filtering..."; rStatus.TextColor3 = data.accent
    task.spawn(function()
        local ok, body = pcall(function() return game:HttpGet(data.url, true) end)
        if myReq ~= requestId then return end
        if ok then
            rStatus.Text = "Filtered  " .. data.title; rStatus.TextColor3 = Color3.fromRGB(120, 230, 160)
            rContent.Text = applyFilter(body)
        end
    end)
end)

backBtn.Activated:Connect(function()
    Tween(backBtn, dur(0.05), { BackgroundColor3 = Color3.fromRGB(28, 32, 46) })
    task.delay(0.05, function() Tween(backBtn, dur(0.10), { BackgroundColor3 = C.bgPanel }) end)
    if type(context.BackToMain) == "function" then context.BackToMain()
    elseif type(context.LoadFunction) == "function" then context.LoadFunction() end
end)

setActive(1)

local connection
connection = RunService.RenderStepped:Connect(function()
    if not root.Parent then connection:Disconnect(); return end
    local a = accent()
    backStroke.Color = a; sStroke.Color = a
    sLens.UIStroke.Color = a; sHandle.BackgroundColor3 = a
    ba1.BackgroundColor3 = a; ba2.BackgroundColor3 = a
    rIcon.UIStroke.Color = a
    for i, t in ipairs(tabButtons) do
        t.cardStroke.Color = a
        t.ibStroke.Color = t.data.accent
    end
end)

return { Root = root }
