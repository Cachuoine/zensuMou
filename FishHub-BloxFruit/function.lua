--// FishHub • Function.lua
--// Advanced Function tab UI
--// Keeps the Function tab focused on navigation/loading function modules.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player then return end

local context = ...
local playerGui = (context and context.PlayerGui) or player:WaitForChild("PlayerGui", 10)
local tab = context and context.Tab
local main = context and context.MainWindow

if not tab then
    local fishHub = playerGui and playerGui:FindFirstChild("FishHub")
    local mainWindow = fishHub and fishHub:FindFirstChild("MainWindow")
    local content = mainWindow and mainWindow:FindFirstChild("ContentContainer")
    tab = content and content:FindFirstChild("FunctionTab", true)
    main = main or mainWindow
end

if not tab then return end

for _, child in ipairs(tab:GetChildren()) do
    child:Destroy()
end

local function getTheme()
    local stroke = main and main:FindFirstChildOfClass("UIStroke")
    return stroke and stroke.Color or Color3.fromRGB(104, 82, 255)
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

local function stroke(parent, transparency)
    local s = Instance.new("UIStroke")
    s.Color = getTheme()
    s.Thickness = 1
    s.Transparency = transparency or .55
    s.Parent = parent
    return s
end

local function label(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size
    l.TextColor3 = color
    l.Font = font or Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Parent = parent
    return l
end

local function tween(obj, props, duration)
    return TweenService:Create(
        obj,
        TweenInfo.new(duration or .2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    )
end

local accentObjects = {}
local strokeObjects = {}
local accentLabels = {}

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "FunctionScroll"
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 0
scroll.CanvasSize = UDim2.new()
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.Parent = tab

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 7)
padding.PaddingRight = UDim.new(0, 7)
padding.PaddingTop = UDim.new(0, 7)
padding.PaddingBottom = UDim.new(0, 14)
padding.Parent = scroll

local root = Instance.new("Frame")
root.Name = "FunctionContent"
root.Size = UDim2.new(1, -14, 0, 0)
root.AutomaticSize = Enum.AutomaticSize.Y
root.BackgroundTransparency = 1
root.Parent = scroll

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0.5, -7, 0, 92)
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.FillDirection = Enum.FillDirection.Horizontal
grid.FillDirectionMaxCells = 2
grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.Parent = root

--// Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 105)
header.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
header.BorderSizePixel = 0
header.ClipsDescendants = true
header.Parent = root
corner(header, 15)
table.insert(strokeObjects, stroke(header, .38))

local glow = Instance.new("Frame")
glow.Size = UDim2.new(0, 160, 0, 160)
glow.Position = UDim2.new(1, -90, 0, -75)
glow.BackgroundColor3 = getTheme()
glow.BackgroundTransparency = .88
glow.BorderSizePixel = 0
glow.Parent = header
corner(glow, 100)
table.insert(accentObjects, glow)

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0, 4, 1, -30)
bar.Position = UDim2.new(0, 14, 0, 15)
bar.BackgroundColor3 = getTheme()
bar.BorderSizePixel = 0
bar.Parent = header
corner(bar, 4)
table.insert(accentObjects, bar)

local title = label(header, "FUNCTION", 21, Color3.fromRGB(245, 246, 252), Enum.Font.GothamBlack)
title.Position = UDim2.new(0, 30, 0, 14)
title.Size = UDim2.new(1, -44, 0, 26)

local subtitle = label(header, "Tools & modules", 10, Color3.fromRGB(145, 150, 165), Enum.Font.GothamMedium)
subtitle.Position = UDim2.new(0, 31, 0, 43)
subtitle.Size = UDim2.new(1, -44, 0, 18)

local count = label(header, "07 MODULES", 9, getTheme(), Enum.Font.GothamBold)
count.Position = UDim2.new(0, 31, 0, 70)
count.Size = UDim2.new(0, 110, 0, 18)
table.insert(accentLabels, count)

--// Search
local search = Instance.new("Frame")
search.Size = UDim2.new(1, 0, 0, 43)
search.BackgroundColor3 = Color3.fromRGB(8, 9, 14)
search.BorderSizePixel = 0
search.Parent = root
corner(search, 12)
table.insert(strokeObjects, stroke(search, .68))

local iconHolder = Instance.new("Frame")
iconHolder.Name = "SearchIcon"
iconHolder.Size = UDim2.new(0, 30, 0, 30)
iconHolder.Position = UDim2.new(0, 11, 0.5, -15)
iconHolder.BackgroundTransparency = 1
iconHolder.Parent = search

local lens = Instance.new("Frame")
lens.Size = UDim2.new(0, 13, 0, 13)
lens.Position = UDim2.new(0, 5, 0, 4)
lens.BackgroundTransparency = 1
lens.BorderSizePixel = 0
lens.Parent = iconHolder
corner(lens, 20)

local lensStroke = Instance.new("UIStroke")
lensStroke.Color = getTheme()
lensStroke.Thickness = 2
lensStroke.Transparency = 0
lensStroke.Parent = lens

local handle = Instance.new("Frame")
handle.Size = UDim2.new(0, 8, 0, 2)
handle.Position = UDim2.new(0, 17, 0, 18)
handle.AnchorPoint = Vector2.new(0, 0.5)
handle.Rotation = 45
handle.BackgroundColor3 = getTheme()
handle.BorderSizePixel = 0
handle.Parent = iconHolder
corner(handle, 2)

table.insert(accentObjects, handle)
table.insert(strokeObjects, lensStroke)

local box = Instance.new("TextBox")
box.Name = "SearchBox"
box.BackgroundTransparency = 1
box.Text = ""
box.PlaceholderText = "Search functions..."
box.PlaceholderColor3 = Color3.fromRGB(105, 110, 125)
box.TextColor3 = Color3.fromRGB(235, 237, 244)
box.TextSize = 10
box.Font = Enum.Font.GothamMedium
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Left
box.Size = UDim2.new(1, -52, 1, 0)
box.Position = UDim2.new(0, 48, 0, 0)
box.Parent = search

local modules = {
    {name="SHOP", key="Shop", desc="Open shop utilities and item controls."},
    {name="SETTING FARM", key="SettingFarm", desc="Configure farming preferences."},
    {name="FARM", key="Farm", desc="Access farming functions."},
    {name="ITEM & QUEST", key="ItemQuest", desc="Items, quests and related utilities."},
    {name="ISLAND", key="Island", desc="Island and travel functions."},
    {name="FRUIT", key="Fruit", desc="Fruit utilities and controls."},
    {name="SETTING", key="Setting", desc="Open FishHub settings."},
}

local cards = {}

local function showToast(text)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 230, 0, 42)
    toast.AnchorPoint = Vector2.new(1, 1)
    toast.Position = UDim2.new(1, -12, 1, -12)
    toast.BackgroundColor3 = Color3.fromRGB(10, 11, 17)
    toast.BorderSizePixel = 0
    toast.ZIndex = 100
    toast.Parent = tab
    corner(toast, 11)
    local s = stroke(toast, .45)
    s.ZIndex = 100

    local t = label(toast, text, 9, Color3.fromRGB(235, 237, 244), Enum.Font.GothamBold)
    t.Position = UDim2.new(0, 13, 0, 0)
    t.Size = UDim2.new(1, -26, 1, 0)
    t.ZIndex = 101

    toast.Position = UDim2.new(1, 250, 1, -12)
    tween(toast, {Position=UDim2.new(1, -12, 1, -12)}, .28):Play()

    task.delay(2.2, function()
        if toast.Parent then
            tween(toast, {Position=UDim2.new(1, 250, 1, -12)}, .25):Play()
            task.wait(.3)
            toast:Destroy()
        end
    end)
end

local function resolveLoader(key)
    -- Optional URL bridge: if the main script exposes a loader, use it.
    if context then
        if type(context.LoadFunction) == "function" then
            return function()
                return context.LoadFunction(key)
            end
        end

        if type(context.Navigate) == "function" then
            return function()
                return context.Navigate(key)
            end
        end
    end

    -- If the existing hub already has a tab navigation bridge, use it.
    if main then
        local event = main:FindFirstChild("Navigate")
        if event and event:IsA("BindableEvent") then
            return function()
                event:Fire(key)
            end
        end
    end

    return nil
end

local function makeCard(data)
    local card = Instance.new("TextButton")
    card.Name = data.key .. "Card"
    card.AutoButtonColor = false
    card.Text = ""
    card.Size = UDim2.new(1, 0, 0, 92)
    card.BackgroundColor3 = Color3.fromRGB(9, 10, 15)
    card.BorderSizePixel = 0
    card.Parent = root
    corner(card, 12)

    local cardStroke = stroke(card, .72)
    table.insert(strokeObjects, cardStroke)

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 4, 0, 54)
    indicator.Position = UDim2.new(0, 11, .5, -27)
    indicator.BackgroundColor3 = getTheme()
    indicator.BorderSizePixel = 0
    indicator.Parent = card
    corner(indicator, 3)
    table.insert(accentObjects, indicator)

    local name = label(card, data.name, 10, Color3.fromRGB(240, 242, 248), Enum.Font.GothamBold)
    name.Position = UDim2.new(0, 24, 0, 15)
    name.Size = UDim2.new(1, -48, 0, 21)
    name.TextSize = 11

    local desc = label(card, data.desc, 8, Color3.fromRGB(125, 130, 145), Enum.Font.GothamMedium)
    desc.Position = UDim2.new(0, 24, 0, 39)
    desc.Size = UDim2.new(1, -48, 0, 30)
    desc.TextWrapped = true
    desc.TextYAlignment = Enum.TextYAlignment.Top

    local arrow = label(card, "›", 19, getTheme(), Enum.Font.GothamBold)
    arrow.Position = UDim2.new(1, -31, 1, -31)
    arrow.Size = UDim2.new(0, 20, 0, 22)
    arrow.TextXAlignment = Enum.TextXAlignment.Center
    table.insert(accentLabels, arrow)

    cards[#cards + 1] = {card=card, name=name, desc=desc}

    local base = card.BackgroundColor3
    card.MouseEnter:Connect(function()
        tween(card, {BackgroundColor3=Color3.fromRGB(16,17,24)}, .16):Play()
        tween(arrow, {Position=UDim2.new(1,-27,1,-31)}, .16):Play()
    end)

    card.MouseLeave:Connect(function()
        tween(card, {BackgroundColor3=base}, .16):Play()
        tween(arrow, {Position=UDim2.new(1,-31,1,-31)}, .16):Play()
    end)

    card.Activated:Connect(function()
        local loader = resolveLoader(data.key)
        if loader then
            local ok, err = pcall(loader)
            if not ok then
                showToast("Failed to open " .. data.name)
                warn("[FishHub] " .. tostring(err))
            end
        else
            showToast(data.name .. " selected")
        end
    end)
end

for _, data in ipairs(modules) do
    makeCard(data)
end

box:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(box.Text)
    for _, item in ipairs(cards) do
        local visible = query == ""
            or string.find(string.lower(item.name.Text), query, 1, true)
            or string.find(string.lower(item.desc.Text), query, 1, true)

        item.card.Visible = visible
    end
end)

task.spawn(function()
    while tab.Parent do
        local c = getTheme()

        for _, obj in ipairs(accentObjects) do
            if obj.Parent then obj.BackgroundColor3 = c end
        end

        for _, obj in ipairs(accentLabels) do
            if obj.Parent then obj.TextColor3 = c end
        end

        for _, s in ipairs(strokeObjects) do
            if s.Parent then s.Color = c end
        end

        task.wait(.08)
    end
end)
