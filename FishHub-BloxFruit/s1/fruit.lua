local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}

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

local function Corner(parent, radius)
    return New("UICorner", { Parent = parent, CornerRadius = UDim.new(0, radius) })
end

local function Stroke(parent, thickness, transparency)
    return New("UIStroke", {
        Parent = parent,
        Color = accent(),
        Thickness = thickness or 1,
        Transparency = transparency or 0.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function Tween(obj, duration, props, style, direction)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
        props
    )
    t:Play()
    return t
end

-- ============================================
-- CONFIG
-- ============================================
local SECTION_TITLE = "FRUIT"
local TABS = {
    { name = "Dealer", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/fruit/dealer.lua" },
    { name = "Fruit",  url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/fruit/fruit.lua" },
    { name = "Raid",   url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/fruit/raid.lua" },
}

-- ============================================
-- LAYOUT
-- ============================================
local BUTTON_HEIGHT    = 40
local BUTTON_GAP       = 6
local MENU_PAD_TOP     = 14
local HEADER_HEIGHT    = 14
local HEADER_GAP       = 12
local INDICATOR_X      = 4
local INDICATOR_WIDTH  = 3
local INDICATOR_INSET  = 6

-- ============================================
-- CLEAR TAB
-- ============================================
for _, child in ipairs(Tab:GetChildren()) do child:Destroy() end
Tab.BackgroundTransparency      = 1
Tab.BorderSizePixel             = 0
Tab.ScrollBarThickness          = 0
Tab.ScrollBarImageTransparency  = 1
Tab.AutomaticCanvasSize         = Enum.AutomaticSize.Y
Tab.CanvasSize                  = UDim2.new(0, 0, 0, 0)

-- ============================================
-- ROOT
-- ============================================
local root = New("Frame", { Parent = Tab, Size = UDim2.new(1, -10, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 })
New("UIPadding", { Parent = root, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) })
New("UIListLayout", { Parent = root, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })

-- ============================================
-- TOP BAR
-- ============================================
local topBar = New("Frame", { Parent = root, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 45), BackgroundTransparency = 1 })
local backBtn = New("TextButton", { Parent = topBar, Size = UDim2.fromOffset(45, 45), BackgroundColor3 = Color3.fromRGB(12, 13, 19), AutoButtonColor = false, Text = "" })
Corner(backBtn, 10)
local backStroke = Stroke(backBtn, 1, 0.4)
local arrowLabel = New("TextLabel", { Parent = backBtn, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "←", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = accent() })
local searchBox = New("Frame", { Parent = topBar, Position = UDim2.new(0, 55, 0, 0), Size = UDim2.new(1, -55, 1, 0), BackgroundColor3 = Color3.fromRGB(12, 13, 19) })
Corner(searchBox, 10)
local searchStroke = Stroke(searchBox, 1, 0.4)
New("TextLabel", { Parent = searchBox, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0, 20, 1, 0), BackgroundTransparency = 1, Text = "🔍", TextSize = 14, TextColor3 = Color3.fromRGB(140, 145, 160) })
New("TextBox", { Parent = searchBox, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, ClearTextOnFocus = false, PlaceholderText = "search...", PlaceholderColor3 = Color3.fromRGB(100, 105, 120), Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left })

-- ============================================
-- MAIN AREA
-- ============================================
local mainArea = New("Frame", { Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ClipsDescendants = false })

local leftMenu = New("Frame", { Parent = mainArea, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0.28, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(10, 11, 17), BackgroundTransparency = 0.25 })
Corner(leftMenu, 12)
local leftStroke = Stroke(leftMenu, 1, 0.55)
New("UIGradient", { Parent = leftMenu, Rotation = 90, Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 16, 23)), ColorSequenceKeypoint.new(0.6, Color3.fromRGB(10, 11, 17)), ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 8, 13)) }) })

local headerFrame = New("Frame", { Parent = leftMenu, Position = UDim2.new(0, 12, 0, MENU_PAD_TOP), Size = UDim2.new(1, -24, 0, HEADER_HEIGHT), BackgroundTransparency = 1 })
local headerLabel = New("TextLabel", { Parent = headerFrame, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = SECTION_TITLE, Font = Enum.Font.GothamBlack, TextSize = 9, TextColor3 = Color3.fromRGB(95, 100, 115), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center })
local headerLine = New("Frame", { Parent = leftMenu, Position = UDim2.new(0, 12, 0, MENU_PAD_TOP + HEADER_HEIGHT + 2), Size = UDim2.new(1, -24, 0, 1), BackgroundColor3 = Color3.fromRGB(35, 40, 55), BackgroundTransparency = 0.5, BorderSizePixel = 0 })
Corner(headerLine, 4)

local tabButtons = {}
local activeTab = nil
local tabStartY = MENU_PAD_TOP + HEADER_HEIGHT + HEADER_GAP

for i, tabData in ipairs(TABS) do
    local yPos = tabStartY + (i - 1) * (BUTTON_HEIGHT + BUTTON_GAP)
    local btn = New("TextButton", { Parent = leftMenu, Position = UDim2.new(0, 8, 0, yPos), Size = UDim2.new(1, -16, 0, BUTTON_HEIGHT), BackgroundColor3 = Color3.fromRGB(15, 16, 23), BackgroundTransparency = 0.65, AutoButtonColor = false, Text = "" })
    Corner(btn, 10)
    local btnStroke = Stroke(btn, 1, 0.7)
    New("UIGradient", { Parent = btn, Rotation = 90, Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 24, 32)), ColorSequenceKeypoint.new(1, Color3.fromRGB(11, 12, 18)) }) })
    local dot = New("Frame", { Parent = btn, Position = UDim2.new(0, 12, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.fromOffset(5, 5), BackgroundColor3 = Color3.fromRGB(100, 110, 130), BackgroundTransparency = 0, BorderSizePixel = 0 })
    Corner(dot, 99)
    local lbl = New("TextLabel", { Parent = btn, Position = UDim2.new(0, 26, 0, 0), Size = UDim2.new(1, -34, 1, 0), BackgroundTransparency = 1, Text = tabData.name, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.fromRGB(160, 165, 180), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center })
    tabButtons[i] = { btn = btn, stroke = btnStroke, dot = dot, label = lbl, data = tabData }
    btn.MouseEnter:Connect(function()
        if activeTab ~= i then
            Tween(btn, 0.2, { BackgroundTransparency = 0.35 })
            Tween(dot, 0.2, { BackgroundColor3 = Color3.fromRGB(180, 190, 210), BackgroundTransparency = 0.3 })
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= i then
            Tween(btn, 0.2, { BackgroundTransparency = 0.65 })
            Tween(dot, 0.2, { BackgroundColor3 = Color3.fromRGB(100, 110, 130), BackgroundTransparency = 0 })
        end
    end)
    btn.Activated:Connect(function() setActive(i) end)
end

local indicatorY0 = tabStartY + INDICATOR_INSET
local indicator = New("Frame", { Parent = leftMenu, Position = UDim2.new(0, INDICATOR_X, 0, indicatorY0), Size = UDim2.new(0, INDICATOR_WIDTH, 0, BUTTON_HEIGHT - INDICATOR_INSET * 2), BackgroundColor3 = accent(), BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 10 })
Corner(indicator, 4)
local indicatorGlow = New("Frame", { Parent = leftMenu, Position = UDim2.new(0, INDICATOR_X - 2, 0, indicatorY0 - 3), Size = UDim2.new(0, INDICATOR_WIDTH + 4, 0, BUTTON_HEIGHT - INDICATOR_INSET * 2 + 6), BackgroundColor3 = accent(), BackgroundTransparency = 0.75, BorderSizePixel = 0, ZIndex = 9 })
Corner(indicatorGlow, 4)

task.spawn(function()
    while indicator and indicator.Parent do
        Tween(indicatorGlow, 0.9, { BackgroundTransparency = 0.55, Size = UDim2.new(0, INDICATOR_WIDTH + 6, 0, BUTTON_HEIGHT - INDICATOR_INSET * 2 + 10) }, Enum.EasingStyle.Sine)
        task.wait(0.9)
        if not (indicator and indicator.Parent) then break end
        Tween(indicatorGlow, 0.9, { BackgroundTransparency = 0.8, Size = UDim2.new(0, INDICATOR_WIDTH + 4, 0, BUTTON_HEIGHT - INDICATOR_INSET * 2 + 6) }, Enum.EasingStyle.Sine)
        task.wait(0.9)
    end
end)

local divider = New("Frame", { Parent = mainArea, Position = UDim2.new(0.28, 4, 0, 0), Size = UDim2.new(0, 1, 0, 0), BackgroundColor3 = Color3.fromRGB(45, 50, 65), BackgroundTransparency = 0.3, BorderSizePixel = 0 })

local rightContent = New("Frame", { Parent = mainArea, Position = UDim2.new(0.28, 8, 0, 0), Size = UDim2.new(0.72, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.25 })
Corner(rightContent, 12)
local rightStroke = Stroke(rightContent, 1, 0.55)
New("UIGradient", { Parent = rightContent, Rotation = 90, Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(13, 14, 21)), ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 8, 13)) }) })
New("UIPadding", { Parent = rightContent, PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) })

-- ============================================
-- ACTIVE TAB LOGIC
-- ============================================
local function setActive(index)
    if activeTab == index then return end
    if activeTab then
        local prev = tabButtons[activeTab]
        Tween(prev.btn, 0.22, { BackgroundTransparency = 0.65 })
        Tween(prev.stroke, 0.22, { Transparency = 0.7, Thickness = 1 })
        Tween(prev.dot, 0.22, { BackgroundColor3 = Color3.fromRGB(100, 110, 130), BackgroundTransparency = 0 })
        Tween(prev.label, 0.22, { TextColor3 = Color3.fromRGB(160, 165, 180) })
    end
    activeTab = index
    local cur = tabButtons[index]
    Tween(cur.btn, 0.22, { BackgroundTransparency = 0.05 })
    Tween(cur.stroke, 0.22, { Transparency = 0, Thickness = 1.4 })
    Tween(cur.dot, 0.22, { BackgroundColor3 = accent(), BackgroundTransparency = 0 })
    Tween(cur.label, 0.22, { TextColor3 = Color3.fromRGB(245, 246, 252) })

    local targetY = tabStartY + (index - 1) * (BUTTON_HEIGHT + BUTTON_GAP) + INDICATOR_INSET
    Tween(indicator, 0.3, { Position = UDim2.new(0, INDICATOR_X, 0, targetY) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    Tween(indicatorGlow, 0.3, { Position = UDim2.new(0, INDICATOR_X - 2, 0, targetY - 3) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    loadTabContent(cur.data.url, cur.data.name)
end

local function clearContent()
    for _, c in ipairs(rightContent:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextLabel") or c:IsA("TextButton")
            or c:IsA("ScrollingFrame") or c:IsA("ImageLabel") or c:IsA("ImageButton") then
            c:Destroy()
        end
    end
end

local function loadTabContent(url, name)
    clearContent()
    local loading = New("TextLabel", { Parent = rightContent, Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = "loading " .. name:lower() .. "...", Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = Color3.fromRGB(110, 115, 130), TextXAlignment = Enum.TextXAlignment.Left })
    task.spawn(function()
        local success, result = pcall(function() return game:HttpGet(url) end)
        if loading and loading.Parent then loading:Destroy() end
        if success and result then
            local fn = loadstring(result)
            if fn then
                local subContext = {}
                for k, v in pairs(context) do subContext[k] = v end
                subContext.Tab     = rightContent
                subContext.Root    = rightContent
                subContext.Content = rightContent
                pcall(fn, subContext)
            end
        else
            New("TextLabel", { Parent = rightContent, Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Text = "failed to load content", Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = Color3.fromRGB(220, 100, 100), TextXAlignment = Enum.TextXAlignment.Left })
        end
    end)
end

backBtn.Activated:Connect(function()
    if type(context.BackToMain) == "function" then context.BackToMain()
    elseif type(context.LoadFunction) == "function" then context.LoadFunction() end
end)

task.spawn(function()
    while mainArea and mainArea.Parent do
        local h = math.max(leftMenu.AbsoluteSize.Y, rightContent.AbsoluteSize.Y)
        if divider.Size.Y.Offset ~= h then
            divider.Size = UDim2.new(0, 1, 0, h)
        end
        task.wait(0.1)
    end
end)

setActive(1)

local connection
connection = RunService.RenderStepped:Connect(function()
    if not root.Parent then connection:Disconnect(); return end
    local a = accent()
    backStroke.Color         = a
    searchStroke.Color       = a
    arrowLabel.TextColor3    = a
    leftStroke.Color         = a
    rightStroke.Color        = a
    indicator.BackgroundColor3   = a
    indicatorGlow.BackgroundColor3 = a
    for _, tb in ipairs(tabButtons) do
        tb.stroke.Color = a
    end
    if activeTab then
        tabButtons[activeTab].dot.BackgroundColor3 = a
    end
end)

return { Root = root }
