--[[
    farm.lua
    Module: FARM
    Tabs: Farm, Fishing, Dungeon, Miss
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}

------------------------------------------------------------
-- Helpers
------------------------------------------------------------
local function accent()
    if Config.Rainbow or Config.RainbowMode then
        return Color3.fromHSV((tick() % 5) / 5, 1, 1)
    end
    return typeof(Config.ThemeColor) == "Color3" and Config.ThemeColor or Color3.fromRGB(0, 229, 255)
end

local function New(class, props)
    local obj = Instance.new(class)
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
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

local function Tween(obj, duration, props, style, direction)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(
            duration or 0.22,
            style or Enum.EasingStyle.Quint,
            direction or Enum.EasingDirection.Out
        ),
        props
    )
    t:Play()
    return t
end

------------------------------------------------------------
-- Configuration
------------------------------------------------------------
local PAGE_TITLE = "FARM"
local TABS = {
    {
        name = "Farm",
        url  = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/farm.lua",
        desc = "Main farming module",
        body = "Main farm module loaded. Configure targets, routes, and auto-farm behavior here."
    },
    {
        name = "Fishing",
        url  = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/fishing.lua",
        desc = "Fishing utilities",
        body = "Fishing module loaded. Auto-cast, auto-reel, and fish-tracking helpers are active."
    },
    {
        name = "Dungeon",
        url  = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/dungeon.lua",
        desc = "Dungeon helpers",
        body = "Dungeon module loaded. Helpers for clearing dungeons, finding rooms, and tracking objectives."
    },
    {
        name = "Miss",
        url  = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/missfarm.lua",
        desc = "Miscellaneous farm tools",
        body = "Miscellaneous farm tools loaded. Catch-all helpers that don't belong to a dedicated tab."
    },
}

local TAB_HEIGHT  = 40
local TAB_GAP     = 6
local MENU_PAD    = 10
local MAIN_H      = 320

------------------------------------------------------------
-- Clear & Setup
------------------------------------------------------------
for _, c in ipairs(Tab:GetChildren()) do c:Destroy() end

Tab.BackgroundTransparency     = 1
Tab.BorderSizePixel            = 0
Tab.ScrollBarThickness         = 0
Tab.ScrollBarImageTransparency = 1
Tab.AutomaticCanvasSize        = Enum.AutomaticSize.Y

------------------------------------------------------------
-- Root
------------------------------------------------------------
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

------------------------------------------------------------
-- Top bar (back + search)
------------------------------------------------------------
local topBar = New("Frame", {
    Parent = root,
    LayoutOrder = 1,
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundTransparency = 1
})

local backBtn = New("TextButton", {
    Parent = topBar,
    Size = UDim2.fromOffset(45, 45),
    BackgroundColor3 = Color3.fromRGB(12, 13, 19),
    AutoButtonColor = false,
    Text = ""
})
Corner(backBtn, 10)
local backStroke = Stroke(backBtn, 1, 0.4)
local arrowLabel = New("TextLabel", {
    Parent = backBtn,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "←",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = accent()
})

local searchBox = New("Frame", {
    Parent = topBar,
    Position = UDim2.new(0, 55, 0, 0),
    Size = UDim2.new(1, -55, 1, 0),
    BackgroundColor3 = Color3.fromRGB(12, 13, 19)
})
Corner(searchBox, 10)
local searchStroke = Stroke(searchBox, 1, 0.4)
New("TextLabel", {
    Parent = searchBox,
    Position = UDim2.new(0, 12, 0, 0),
    Size = UDim2.new(0, 20, 1, 0),
    BackgroundTransparency = 1,
    Text = "⌕",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(140, 145, 160)
})
New("TextBox", {
    Parent = searchBox,
    Position = UDim2.new(0, 38, 0, 0),
    Size = UDim2.new(1, -48, 1, 0),
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

------------------------------------------------------------
-- Main split
------------------------------------------------------------
local LEFT_W = 124
local GAP    = 10

local mainFrame = New("Frame", {
    Parent = root,
    LayoutOrder = 2,
    Size = UDim2.new(1, 0, 0, MAIN_H),
    BackgroundTransparency = 1,
    ClipsDescendants = true
})

local leftMenu = New("Frame", {
    Parent = mainFrame,
    Size = UDim2.new(0, LEFT_W, 1, 0),
    BackgroundColor3 = Color3.fromRGB(10, 11, 17),
    BackgroundTransparency = 0.1
})
Corner(leftMenu, 12)
local leftStroke = Stroke(leftMenu, 1, 0.55)
New("UIGradient", {
    Parent = leftMenu,
    Rotation = 90,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 20, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 8, 13))
    })
})

local rightContent = New("Frame", {
    Parent = mainFrame,
    Position = UDim2.new(0, LEFT_W + GAP, 0, 0),
    Size = UDim2.new(1, -(LEFT_W + GAP), 1, 0),
    BackgroundColor3 = Color3.fromRGB(8, 9, 14),
    BackgroundTransparency = 0.05
})
Corner(rightContent, 12)
local rightStroke = Stroke(rightContent, 1, 0.55)
New("UIGradient", {
    Parent = rightContent,
    Rotation = 90,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 16, 24)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 7, 12))
    })
})

------------------------------------------------------------
-- Tab list (left)
------------------------------------------------------------
local tabList = New("Frame", {
    Parent = leftMenu,
    Position = UDim2.new(0, MENU_PAD, 0, MENU_PAD),
    Size = UDim2.new(1, -MENU_PAD * 2, 1, -MENU_PAD * 2),
    BackgroundTransparency = 1,
    ClipsDescendants = true
})
New("UIListLayout", {
    Parent = tabList,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, TAB_GAP)
})

local tabIndicator = New("Frame", {
    Parent = leftMenu,
    Position = UDim2.new(0, 2, 0, MENU_PAD + 2),
    Size = UDim2.new(0, 3, 0, TAB_HEIGHT - 4),
    BackgroundColor3 = accent(),
    BorderSizePixel = 0
})
Corner(tabIndicator, 2)
New("UIGradient", {
    Parent = tabIndicator,
    Rotation = 90,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, accent())
    })
})
local indicatorGlow = New("Frame", {
    Parent = tabIndicator,
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.fromScale(5, 1.6),
    BackgroundColor3 = accent(),
    BackgroundTransparency = 0.7,
    BorderSizePixel = 0
})
Corner(indicatorGlow, 4)
New("UIGradient", {
    Parent = indicatorGlow,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.55),
        NumberSequenceKeypoint.new(1, 0)
    })
})

------------------------------------------------------------
-- Right content body
------------------------------------------------------------
local rightTitle = New("TextLabel", {
    Parent = rightContent,
    Position = UDim2.new(0, 20, 0, 16),
    Size = UDim2.new(1, -130, 0, 24),
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.GothamBlack,
    TextSize = 15,
    TextColor3 = Color3.fromRGB(245, 246, 252),
    TextXAlignment = Enum.TextXAlignment.Left
})

local rightSubtitle = New("TextLabel", {
    Parent = rightContent,
    Position = UDim2.new(0, 20, 0, 40),
    Size = UDim2.new(1, -40, 0, 14),
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 9,
    TextColor3 = Color3.fromRGB(125, 130, 145),
    TextXAlignment = Enum.TextXAlignment.Left
})

local statusBadge = New("Frame", {
    Parent = rightContent,
    Position = UDim2.new(1, -110, 0, 18),
    Size = UDim2.new(0, 0, 0, 22),
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(15, 17, 25),
    BorderSizePixel = 0
})
Corner(statusBadge, 8)
local statusStroke = Stroke(statusBadge, 1, 0.5)
New("UIPadding", {
    Parent = statusBadge,
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10)
})
local statusLabel = New("TextLabel", {
    Parent = statusBadge,
    Size = UDim2.new(0, 0, 1, 0),
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundTransparency = 1,
    Text = "● IDLE",
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextColor3 = Color3.fromRGB(140, 145, 160)
})

local rightDivider = New("Frame", {
    Parent = rightContent,
    Position = UDim2.new(0, 18, 0, 64),
    Size = UDim2.new(1, -36, 0, 1),
    BackgroundColor3 = accent(),
    BackgroundTransparency = 0.75,
    BorderSizePixel = 0
})

local rightBody = New("Frame", {
    Parent = rightContent,
    Position = UDim2.new(0, 20, 0, 76),
    Size = UDim2.new(1, -40, 1, -88),
    BackgroundTransparency = 1,
    ClipsDescendants = true
})

local bodyHeading = New("TextLabel", {
    Parent = rightBody,
    Size = UDim2.new(1, 0, 0, 16),
    BackgroundTransparency = 1,
    Text = "▸ MODULE",
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextColor3 = accent(),
    TextXAlignment = Enum.TextXAlignment.Left
})

local bodyText = New("TextLabel", {
    Parent = rightBody,
    Position = UDim2.new(0, 0, 0, 24),
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(210, 215, 225),
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top
})

local bodyMeta = New("TextLabel", {
    Parent = rightBody,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 9,
    TextColor3 = Color3.fromRGB(95, 100, 115),
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Visible = false
})

------------------------------------------------------------
-- Tab buttons
------------------------------------------------------------
local tabButtons = {}
local currentTabIndex = 0
local statusPulseThread = nil

local function setStatus(text, color, pulse)
    if statusPulseThread then
        task.cancel(statusPulseThread)
        statusPulseThread = nil
    end
    if not statusBadge or not statusBadge.Parent then return end
    statusLabel.Text = text
    statusLabel.TextColor3 = color
    statusStroke.Color = color
    if pulse then
        statusPulseThread = task.spawn(function()
            local flip = true
            while statusBadge and statusBadge.Parent do
                if flip then
                    Tween(statusBadge, 0.7, { BackgroundTransparency = 0.45 }, Enum.EasingStyle.Sine)
                else
                    Tween(statusBadge, 0.7, { BackgroundTransparency = 0.05 }, Enum.EasingStyle.Sine)
                end
                flip = not flip
                task.wait(0.7)
            end
        end)
    end
end

local function moveIndicatorTo(index, animate)
    local targetY = MENU_PAD + 2 + (index - 1) * (TAB_HEIGHT + TAB_GAP)
    if animate then
        Tween(tabIndicator, 0.28, { Position = UDim2.new(0, 2, 0, targetY) }, Enum.EasingStyle.Quint)
    else
        tabIndicator.Position = UDim2.new(0, 2, 0, targetY)
    end
end

local function makeTab(index, data)
    local tab = New("TextButton", {
        Parent = tabList,
        LayoutOrder = index,
        AutoButtonColor = false,
        Text = "",
        Size = UDim2.new(1, 0, 0, TAB_HEIGHT),
        BackgroundColor3 = Color3.fromRGB(20, 22, 30),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    Corner(tab, 10)

    New("UIGradient", {
        Parent = tab,
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 26, 36)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 19))
        })
    })

    local tabStroke = Stroke(tab, 1, 0.75)

    local titleLabel = New("TextLabel", {
        Parent = tab,
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(1, -28, 0, 22),
        BackgroundTransparency = 1,
        Text = data.name,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(180, 185, 200),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    local descLabel = New("TextLabel", {
        Parent = tab,
        Position = UDim2.new(0, 14, 0, 22),
        Size = UDim2.new(1, -24, 1, -26),
        BackgroundTransparency = 1,
        Text = data.desc,
        Font = Enum.Font.GothamMedium,
        TextSize = 8,
        TextColor3 = Color3.fromRGB(100, 105, 120),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    local sideDot = New("Frame", {
        Parent = tab,
        Position = UDim2.new(1, -12, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(4, 4),
        BackgroundColor3 = accent(),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    Corner(sideDot, 99)

    tabButtons[index] = {
        button  = tab,
        stroke  = tabStroke,
        title   = titleLabel,
        desc    = descLabel,
        sideDot = sideDot,
        bg      = tab,
    }

    tab.MouseEnter:Connect(function()
        if currentTabIndex ~= index then
            Tween(titleLabel, 0.18, { TextColor3 = Color3.fromRGB(225, 230, 245) })
        end
        Tween(tabStroke, 0.18, { Transparency = 0.45 })
    end)

    tab.MouseLeave:Connect(function()
        if currentTabIndex ~= index then
            Tween(titleLabel, 0.18, { TextColor3 = Color3.fromRGB(180, 185, 200) })
        end
        Tween(tabStroke, 0.18, { Transparency = 0.75 })
    end)

    tab.Activated:Connect(function()
        selectTab(index, true)
    end)
end

local function loadTabContent(data)
    setStatus("● LOADING", Color3.fromRGB(255, 200, 80), true)
    bodyText.Text = "Loading module from remote...\n" .. data.url
    bodyMeta.Visible = false

    task.spawn(function()
        local success, result = pcall(function()
            return game:HttpGet(data.url)
        end)
        if not success or not result then
            setStatus("● ERROR", Color3.fromRGB(255, 90, 90), false)
            bodyText.Text = "Failed to fetch module.\n" .. tostring(result or "Unknown error")
            return
        end

        local fn, err = loadstring(result)
        if not fn then
            setStatus("● ERROR", Color3.fromRGB(255, 90, 90), false)
            bodyText.Text = "Parse error in module script."
            return
        end

        local ok, runtimeErr = pcall(fn, context)
        if not ok then
            setStatus("● ERROR", Color3.fromRGB(255, 90, 90), false)
            bodyText.Text = "Runtime error in module script.\n" .. tostring(runtimeErr)
            return
        end

        setStatus("● ACTIVE", accent(), true)
        bodyText.Text = data.body or ("Module \"" .. data.name .. "\" is now active.")
        bodyMeta.Text = "src  ›  " .. data.url
        bodyMeta.Visible = true
    end)
end

local function selectTab(index, animate)
    if index < 1 or index > #TABS then return end
    if index == currentTabIndex then return end
    currentTabIndex = index

    moveIndicatorTo(index, animate)

    for i, btn in ipairs(tabButtons) do
        if i == index then
            Tween(btn.title, 0.2, { TextColor3 = accent() })
            Tween(btn.desc, 0.2, { TextColor3 = Color3.fromRGB(180, 185, 200) })
            Tween(btn.bg, 0.2, { BackgroundTransparency = 0 })
            Tween(btn.stroke, 0.2, { Transparency = 0.15, Color = accent(), Thickness = 1.4 })
            Tween(btn.sideDot, 0.2, { BackgroundTransparency = 0 })
        else
            Tween(btn.title, 0.2, { TextColor3 = Color3.fromRGB(180, 185, 200) })
            Tween(btn.desc, 0.2, { TextColor3 = Color3.fromRGB(100, 105, 120) })
            Tween(btn.bg, 0.2, { BackgroundTransparency = 1 })
            Tween(btn.stroke, 0.2, { Transparency = 0.75, Color = accent(), Thickness = 1 })
            Tween(btn.sideDot, 0.2, { BackgroundTransparency = 1 })
        end
    end

    local data = TABS[index]
    rightTitle.Text = data.name:upper()
    rightSubtitle.Text = data.desc
    loadTabContent(data)
end

------------------------------------------------------------
-- Build tabs
------------------------------------------------------------
for i, data in ipairs(TABS) do
    makeTab(i, data)
end

------------------------------------------------------------
-- Back button
------------------------------------------------------------
backBtn.Activated:Connect(function()
    if type(context.BackToMain) == "function" then
        context.BackToMain()
    elseif type(context.LoadFunction) == "function" then
        context.LoadFunction()
    end
end)

------------------------------------------------------------
-- Accent color updater
------------------------------------------------------------
local connection
connection = RunService.RenderStepped:Connect(function()
    if not root or not root.Parent then
        connection:Disconnect()
        return
    end
    local a = accent()
    backStroke.Color = a
    searchStroke.Color = a
    leftStroke.Color = a
    rightStroke.Color = a
    tabIndicator.BackgroundColor3 = a
    indicatorGlow.BackgroundColor3 = a
    rightDivider.BackgroundColor3 = a
    bodyHeading.TextColor3 = a
    arrowLabel.TextColor3 = a
    if statusBadge and statusBadge.Parent then
        if statusLabel.TextColor3 ~= Color3.fromRGB(255, 200, 80)
            and statusLabel.TextColor3 ~= Color3.fromRGB(255, 90, 90) then
            statusLabel.TextColor3 = a
            statusStroke.Color = a
        end
    end

    for i, btn in ipairs(tabButtons) do
        if btn.stroke and btn.stroke.Parent then
            if i == currentTabIndex then
                btn.stroke.Color = a
                btn.sideDot.BackgroundColor3 = a
            end
        end
    end
end)

------------------------------------------------------------
-- Sparkle pulse
------------------------------------------------------------
task.spawn(function()
    local flip = true
    while root and root.Parent do
        if currentTabIndex > 0 then
            local btn = tabButtons[currentTabIndex]
            if btn and btn.bg and btn.bg.Parent then
                if flip then
                    Tween(btn.bg, 1.3, { BackgroundTransparency = 0.18 }, Enum.EasingStyle.Sine)
                else
                    Tween(btn.bg, 1.3, { BackgroundTransparency = 0.0 }, Enum.EasingStyle.Sine)
                end
            end
        end
        if indicatorGlow and indicatorGlow.Parent then
            if flip then
                Tween(indicatorGlow, 1.0, { BackgroundTransparency = 0.6 }, Enum.EasingStyle.Sine)
            else
                Tween(indicatorGlow, 1.0, { BackgroundTransparency = 0.85 }, Enum.EasingStyle.Sine)
            end
        end
        flip = not flip
        task.wait(1.3)
    end
end)

------------------------------------------------------------
-- Auto-select first tab
------------------------------------------------------------
task.defer(function()
    if #TABS > 0 then
        selectTab(1, false)
    end
end)

return { Root = root }
