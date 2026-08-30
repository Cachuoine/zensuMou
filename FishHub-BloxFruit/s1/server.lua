-- ============================================================
--  SERVER MODULE
--  Cấu trúc: 2 cột (trái tabs / phải content) + top bar
--  Auto-run tab đầu tiên | Search | Back | Animation kẻ dọc
-- ============================================================

local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local RunService         = game:GetService("RunService")
local HttpService        = game:GetService("HttpService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab    = context.Tab
local Config = context.Config or {}

-- ============================================================
-- CẤU HÌNH TAB & URL
-- ============================================================
local TABS = {
    { Name = "Island Even", URL = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/server/islandeven.lua" },
    { Name = "Boss",        URL = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/server/boss.lua" },
    { Name = "Miss",        URL = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/server/missserver.lua" },
}

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

local function Corner(p, r)  return New("UICorner", { Parent = p, CornerRadius = UDim.new(0, r) }) end
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
-- TOP BAR (Back + Search)
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

-- Search icon (kính lúp vector-style)
local searchIcon = New("TextLabel", {
    Parent = searchBox, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.fromOffset(22, 40),
    BackgroundTransparency = 1, Text = "⌕", Font = Enum.Font.GothamBold, TextSize = 18,
    TextColor3 = Color3.fromRGB(140, 150, 175),
})

local searchInput = New("TextBox", {
    Parent = searchBox, Position = UDim2.new(0, 36, 0, 0), Size = UDim2.new(1, -46, 1, 0),
    BackgroundTransparency = 1, ClearTextOnFocus = false,
    PlaceholderText = "Search server...", PlaceholderColor3 = Color3.fromRGB(95, 100, 120),
    Text = "", Font = Enum.Font.GothamMedium, TextSize = 12,
    TextColor3 = Color3.fromRGB(230, 235, 245), TextXAlignment = Enum.TextXAlignment.Left,
})

-- ============================================================
-- BODY: 2 cột + divider
-- ============================================================
local body = New("Frame", {
    Parent = root, LayoutOrder = 2,
    Size = UDim2.new(1, 0, 0, 400), BackgroundTransparency = 1,
})

-- LEFT COLUMN (menu tabs - 32%)
local leftCol = New("Frame", {
    Parent = body, Size = UDim2.new(0.32, -4, 1, 0),
    BackgroundColor3 = Color3.fromRGB(11, 12, 18), BackgroundTransparency = 0.3,
})
Corner(leftCol, 12)
Stroke(leftCol, 1, 0.6)

local leftList = New("ScrollingFrame", {
    Parent = leftCol, Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
})
Pad(leftList, 6, 6, 4, 4)
New("UIListLayout", { Parent = leftList, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) })

-- DIVIDER
local divider = New("Frame", {
    Parent = body, Position = UDim2.new(0.32, 0, 0, 0),
    Size = UDim2.new(0, 1, 1, 0),
    BackgroundColor3 = Color3.fromRGB(40, 45, 60), BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
})

-- RIGHT COLUMN (content - 68%)
local rightCol = New("Frame", {
    Parent = body, Position = UDim2.new(0.32, 8, 0, 0),
    Size = UDim2.new(0.68, -8, 1, 0),
    BackgroundColor3 = Color3.fromRGB(11, 12, 18), BackgroundTransparency = 0.3,
})
Corner(rightCol, 12)
Stroke(rightCol, 1, 0.6)

-- Header nhỏ trong right col (tên tab hiện tại)
local contentHeader = New("Frame", {
    Parent = rightCol, Size = UDim2.new(1, 0, 0, 32),
    BackgroundTransparency = 1,
})
local headerLine = New("Frame", {
    Parent = contentHeader, Position = UDim2.new(0, 12, 1, -1),
    Size = UDim2.new(0.4, 0, 0, 1), BackgroundColor3 = accent(),
    BackgroundTransparency = 0.3, BorderSizePixel = 0,
})
local headerLabel = New("TextLabel", {
    Parent = contentHeader, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -24, 1, 0),
    BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold, TextSize = 13,
    TextColor3 = Color3.fromRGB(240, 245, 255), TextXAlignment = Enum.TextXAlignment.Left,
})
local headerStatus = New("TextLabel", {
    Parent = contentHeader, Position = UDim2.new(1, -110, 0, 0), Size = UDim2.fromOffset(100, 32),
    BackgroundTransparency = 1, Text = "Loading...", Font = Enum.Font.GothamMedium, TextSize = 10,
    TextColor3 = Color3.fromRGB(120, 130, 150), TextXAlignment = Enum.TextXAlignment.Right,
})

-- Content scroll
local contentInner = New("ScrollingFrame", {
    Parent = rightCol, Position = UDim2.new(0, 0, 0, 34), Size = UDim2.new(1, 0, 1, -34),
    BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
    ScrollBarImageColor3 = accent(), CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
})
Pad(contentInner, 6, 10, 12, 12)
New("UIListLayout", { Parent = contentInner, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) })

-- ============================================================
-- TAB BUTTONS (với kẻ dọc indicator animation)
-- ============================================================
local tabButtons = {}
local activeIndex = 1
local contentItems = {}

local function createTabButton(name, index)
    local btn = New("TextButton", {
        Parent = leftList, Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Color3.fromRGB(14, 16, 24), AutoButtonColor = false, Text = "",
        LayoutOrder = index, ClipsDescendants = true,
    })
    Corner(btn, 8)

    -- Kẻ dọc indicator (bên trái)
    local indicator = New("Frame", {
        Parent = btn, Position = UDim2.new(0, 0, 0.15, 0),
        Size = UDim2.new(0, 3, 0.7, 0),
        BackgroundColor3 = accent(), BackgroundTransparency = 1, BorderSizePixel = 0,
    })
    Corner(indicator, 2)

    -- Glow phụ (gradient strip)
    local indicatorGlow = New("Frame", {
        Parent = btn, Position = UDim2.new(0, 4, 0.1, 0),
        Size = UDim2.new(0, 1, 0.8, 0),
        BackgroundColor3 = accent(), BackgroundTransparency = 1, BorderSizePixel = 0,
    })

    local label = New("TextLabel", {
        Parent = btn, Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(1, -14, 1, 0),
        BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = Color3.fromRGB(150, 158, 180), TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- Hover
    btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(20, 24, 36)}, 0.2) end)
    btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(14, 16, 24)}, 0.2) end)

    return { bg = btn, indicator = indicator, glow = indicatorGlow, label = label, name = name }
end

-- ============================================================
-- CONTENT HELPERS
-- ============================================================
local function clearContent()
    for _, c in ipairs(contentInner:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextLabel") then c:Destroy() end
    end
    contentItems = {}
end

local function addStatusLine(text, order, color)
    local item = New("TextLabel", {
        Parent = contentInner, LayoutOrder = order or 1,
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Text = text, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold,
        TextSize = 12, TextColor3 = color or Color3.fromRGB(150, 160, 180),
    })
    Pad(item, 2, 2, 0, 0)
    return item
end

local function addItem(text, order)
    local item = New("Frame", {
        Parent = contentInner, LayoutOrder = order or #contentItems + 1,
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(18, 20, 30), BackgroundTransparency = 0.4,
    })
    Corner(item, 6)
    local txt = New("TextLabel", {
        Parent = item, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Text = "  " .. text, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
        Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = Color3.fromRGB(210, 215, 230),
    })
    Pad(txt, 6, 6, 8, 8)
    contentItems[#contentItems + 1] = { Frame = item, Text = text:lower() }
    return item
end

local function filterContent(query)
    query = (query or ""):lower()
    for _, it in ipairs(contentItems) do
        if query == "" or it.Text:find(query, 1, true) then
            it.Frame.Visible = true
        else
            it.Frame.Visible = false
        end
    end
end

searchInput:GetPropertyChangedSignal("Text"):Connect(function() filterContent(searchInput.Text) end)

-- ============================================================
-- ACTIVE TAB ANIMATION (kẻ dọc chuyển mượt)
-- ============================================================
local function setActive(idx)
    idx = math.clamp(idx, 1, #TABS)
    activeIndex = idx
    for i, btn in ipairs(tabButtons) do
        local isActive = (i == idx)
        tween(btn.bg, {BackgroundColor3 = isActive and Color3.fromRGB(22, 26, 40) or Color3.fromRGB(14, 16, 24)}, 0.28)
        tween(btn.label, {TextColor3 = isActive and Color3.fromRGB(240, 245, 255) or Color3.fromRGB(150, 158, 180)}, 0.28)
        tween(btn.indicator, {BackgroundTransparency = isActive and 0 or 1}, 0.32, Enum.EasingStyle.Quint)
        tween(btn.glow, {BackgroundTransparency = isActive and 0.55 or 1}, 0.32, Enum.EasingStyle.Quint)
    end
    headerLabel.Text = TABS[idx].Name
end

-- ============================================================
-- LOAD CONTENT FROM URL
-- ============================================================
local function httpGet(url)
    local ok, res = pcall(function()
        if syn and syn.request then
            local r = syn.request({ Url = url, Method = "GET" })
            return r.Body
        elseif request then
            local r = request({ Url = url, Method = "GET" })
            return r.Body
        elseif http_request then
            local r = http_request({ Url = url, Method = "GET" })
            return r.Body
        elseif game and game.HttpGet then
            return game:HttpGet(url)
        end
        return nil
    end)
    if ok and type(res) == "string" and #res > 0 then return res end
    return nil
end

local function loadTab(idx)
    local data = TABS[idx]
    if not data then return end
    clearContent()
    headerStatus.Text = "Loading..."
    headerStatus.TextColor3 = Color3.fromRGB(120, 130, 150)

    addStatusLine("Connecting to source...", 1, Color3.fromRGB(180, 190, 210))
    setActive(idx)

    local body_text = httpGet(data.URL)
    clearContent()
    if not body_text then
        addStatusLine("✖ Failed to load content", 1, Color3.fromRGB(255, 90, 100))
        addStatusLine("URL: " .. data.URL, 2, Color3.fromRGB(120, 130, 150))
        headerStatus.Text = "Error"
        headerStatus.TextColor3 = Color3.fromRGB(255, 90, 100)
        return
    end

    -- Tách thành các dòng, bỏ dòng trống
    local order = 1
    local added = 0
    for line in body_text:gmatch("[^\r\n]+") do
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed and #trimmed > 0 then
            -- Bỏ qua các dòng chỉ là comment thuần hoặc quá dài
            if #trimmed <= 500 then
                addItem(trimmed, order)
                order = order + 1
                added = added + 1
            end
        end
        if added >= 200 then break end
    end

    if added == 0 then
        addStatusLine("No content available", 1, Color3.fromRGB(180, 190, 210))
    end
    headerStatus.Text = "Loaded · " .. added
    headerStatus.TextColor3 = Color3.fromRGB(120, 200, 140)
end

-- ============================================================
-- BUILD TABS & AUTO-RUN FIRST
-- ============================================================
for i, t in ipairs(TABS) do
    tabButtons[i] = createTabButton(t.Name, i)
    tabButtons[i].bg.Activated:Connect(function() loadTab(i) end)
end

task.defer(function()
    loadTab(1)
end)

-- ============================================================
-- LIVE ACCENT (cho rainbow/ThemeColor)
-- ============================================================
local conn
conn = RunService.RenderStepped:Connect(function()
    if not root.Parent then conn:Disconnect() return end
    local a = accent()
    backStroke.Color   = a
    searchStroke.Color = a
    backArrow.TextColor3 = a
    headerLine.BackgroundColor3 = a
    contentInner.ScrollBarImageColor3 = a
    for i, btn in ipairs(tabButtons) do
        btn.indicator.BackgroundColor3 = a
        btn.glow.BackgroundColor3 = a
    end
end)

return { Root = root }
