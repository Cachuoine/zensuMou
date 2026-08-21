--//========================================================
--// FishHub • Function.lua
--// Premium Function Tab
--// Visual pass: cards/tabs upgraded, circular card bubbles removed.
--// Search, module list, filtering and loader behavior preserved.
--//========================================================

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

tab.ClipsDescendants = true

local function getTheme()
    local uiStroke = main and main:FindFirstChildOfClass("UIStroke")
    return uiStroke and uiStroke.Color or Color3.fromRGB(104, 82, 255)
end

local function corner(parent, radius)
    local object = Instance.new("UICorner")
    object.CornerRadius = UDim.new(0, radius)
    object.Parent = parent
    return object
end

local function stroke(parent, transparency, thickness)
    local object = Instance.new("UIStroke")
    object.Color = getTheme()
    object.Thickness = thickness or 1
    object.Transparency = transparency or 0.55
    object.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    object.Parent = parent
    return object
end

local function label(parent, text, size, color, font)
    local object = Instance.new("TextLabel")
    object.BackgroundTransparency = 1
    object.Text = text
    object.TextSize = size
    object.TextColor3 = color
    object.Font = font or Enum.Font.GothamMedium
    object.TextXAlignment = Enum.TextXAlignment.Left
    object.TextYAlignment = Enum.TextYAlignment.Center
    object.Parent = parent
    return object
end

local function tween(object, properties, duration)
    return TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.2,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        properties
    )
end

local accentObjects = {}
local strokeObjects = {}
local accentLabels = {}
local cards = {}

--========================================================
-- SCROLL
--========================================================
local scroll = Instance.new("ScrollingFrame")
scroll.Name = "FunctionScroll"
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 0
scroll.ScrollBarImageTransparency = 1
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
grid.Name = "FunctionGrid"
grid.CellSize = UDim2.new(0.5, -6, 0, 104)
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.FillDirection = Enum.FillDirection.Horizontal
grid.FillDirectionMaxCells = 2
grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.Parent = root

--========================================================
-- HEADER
--========================================================
local header = Instance.new("Frame")
header.Name = "FunctionHeader"
header.Size = UDim2.new(1, 0, 0, 105)
header.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
header.BorderSizePixel = 0
header.ClipsDescendants = true
header.Parent = root
corner(header, 15)

local headerStroke = stroke(header, 0.34, 1.2)
table.insert(strokeObjects, headerStroke)

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 8, 12)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(13, 15, 23)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 8, 12))
})
headerGradient.Rotation = 15
headerGradient.Parent = header

local headerGlow = Instance.new("Frame")
headerGlow.Name = "HeaderGlow"
headerGlow.Size = UDim2.new(0, 190, 0, 190)
headerGlow.Position = UDim2.new(1, -90, 0, -92)
headerGlow.BackgroundColor3 = getTheme()
headerGlow.BackgroundTransparency = 0.90
headerGlow.BorderSizePixel = 0
headerGlow.Parent = header
corner(headerGlow, 100)
table.insert(accentObjects, headerGlow)

local accentBar = Instance.new("Frame")
accentBar.Name = "AccentBar"
accentBar.Size = UDim2.new(0, 4, 1, -30)
accentBar.Position = UDim2.new(0, 14, 0, 15)
accentBar.BackgroundColor3 = getTheme()
accentBar.BorderSizePixel = 0
accentBar.Parent = header
corner(accentBar, 4)
table.insert(accentObjects, accentBar)

local title = label(header, "FUNCTION", 21,
    Color3.fromRGB(245, 246, 252), Enum.Font.GothamBlack)
title.Position = UDim2.new(0, 30, 0, 12)
title.Size = UDim2.new(1, -44, 0, 28)

local subtitle = label(header, "Tools  •  Modules  •  Utilities", 10,
    Color3.fromRGB(145, 150, 165), Enum.Font.GothamMedium)
subtitle.Position = UDim2.new(0, 31, 0, 42)
subtitle.Size = UDim2.new(1, -44, 0, 18)

local count = label(header, "07 MODULES", 9, getTheme(), Enum.Font.GothamBold)
count.Position = UDim2.new(0, 31, 0, 70)
count.Size = UDim2.new(0, 120, 0, 18)
table.insert(accentLabels, count)

local statusDot = Instance.new("Frame")
statusDot.Name = "StatusDot"
statusDot.Size = UDim2.new(0, 6, 0, 6)
statusDot.Position = UDim2.new(1, -88, 0, 77)
statusDot.BackgroundColor3 = getTheme()
statusDot.BorderSizePixel = 0
statusDot.Parent = header
corner(statusDot, 10)
table.insert(accentObjects, statusDot)

local statusText = label(header, "READY", 8,
    Color3.fromRGB(135, 140, 155), Enum.Font.Code)
statusText.Position = UDim2.new(1, -76, 0, 70)
statusText.Size = UDim2.new(0, 60, 0, 18)
statusText.TextXAlignment = Enum.TextXAlignment.Right

--========================================================
-- SEARCH BAR — kept functionally unchanged.
--========================================================
local search = Instance.new("Frame")
search.Name = "FunctionSearch"
search.Size = UDim2.new(1, 0, 0, 44)
search.BackgroundColor3 = Color3.fromRGB(8, 9, 14)
search.BorderSizePixel = 0
search.Parent = root
corner(search, 12)

local searchStroke = stroke(search, 0.63, 1)
table.insert(strokeObjects, searchStroke)

local searchGlow = Instance.new("Frame")
searchGlow.Name = "SearchGlow"
searchGlow.Size = UDim2.new(0, 90, 0, 90)
searchGlow.Position = UDim2.new(0, -22, 0.5, -45)
searchGlow.BackgroundColor3 = getTheme()
searchGlow.BackgroundTransparency = 0.96
searchGlow.BorderSizePixel = 0
searchGlow.Parent = search
corner(searchGlow, 100)
table.insert(accentObjects, searchGlow)

local iconHolder = Instance.new("Frame")
iconHolder.Name = "SearchIcon"
iconHolder.Size = UDim2.new(0, 32, 0, 32)
iconHolder.Position = UDim2.new(0, 10, 0.5, -16)
iconHolder.BackgroundTransparency = 1
iconHolder.Parent = search

local lens = Instance.new("Frame")
lens.Size = UDim2.new(0, 14, 0, 14)
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
table.insert(strokeObjects, lensStroke)

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
box.Size = UDim2.new(1, -88, 1, 0)
box.Position = UDim2.new(0, 48, 0, 0)
box.Parent = search

local clearButton = Instance.new("TextButton")
clearButton.Name = "ClearSearch"
clearButton.Size = UDim2.new(0, 30, 0, 30)
clearButton.Position = UDim2.new(1, -38, 0.5, -15)
clearButton.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
clearButton.BorderSizePixel = 0
clearButton.AutoButtonColor = false
clearButton.Text = "×"
clearButton.TextSize = 16
clearButton.Font = Enum.Font.GothamBold
clearButton.TextColor3 = Color3.fromRGB(145, 150, 165)
clearButton.Visible = false
clearButton.Parent = search
corner(clearButton, 8)

clearButton.MouseEnter:Connect(function()
    tween(clearButton, {
        BackgroundColor3 = Color3.fromRGB(28, 30, 40),
        TextColor3 = getTheme()
    }, 0.15):Play()
end)

clearButton.MouseLeave:Connect(function()
    tween(clearButton, {
        BackgroundColor3 = Color3.fromRGB(18, 20, 28),
        TextColor3 = Color3.fromRGB(145, 150, 165)
    }, 0.15):Play()
end)

clearButton.Activated:Connect(function()
    box.Text = ""
    box:CaptureFocus()
end)

box.Focused:Connect(function()
    tween(searchStroke, {Transparency = 0.05, Thickness = 1.25}, 0.18):Play()
    tween(searchGlow, {BackgroundTransparency = 0.91}, 0.18):Play()
end)

box.FocusLost:Connect(function()
    tween(searchStroke, {Transparency = 0.63, Thickness = 1}, 0.18):Play()
    tween(searchGlow, {BackgroundTransparency = 0.96}, 0.18):Play()
end)

--========================================================
-- MODULES
--========================================================
local modules = {
    {name = "SHOP", key = "Shop", desc = "Open shop utilities and item controls.", icon = "S"},
    {name = "SETTING FARM", key = "SettingFarm", desc = "Configure farming preferences and behavior.", icon = "F"},
    {name = "FARM", key = "Farm", desc = "Access farming functions and automation.", icon = "A"},
    {name = "ITEM & QUEST", key = "ItemQuest", desc = "Items, quests and related utilities.", icon = "Q"},
    {name = "ISLAND", key = "Island", desc = "Island navigation and travel functions.", icon = "I"},
    {name = "FRUIT", key = "Fruit", desc = "Fruit utilities, controls and helpers.", icon = "F"},
    {name = "SETTING", key = "Setting", desc = "Open FishHub settings and interface controls.", icon = "G"}
}

--========================================================
-- TOAST
--========================================================
local function showToast(text)
    if context and type(context.ShowNotification) == "function" then
        pcall(context.ShowNotification, tostring(text))
        return
    end

    local toast = Instance.new("Frame")
    toast.Name = "FunctionToast"
    toast.Size = UDim2.new(0, 250, 0, 46)
    toast.AnchorPoint = Vector2.new(1, 1)
    toast.Position = UDim2.new(1, 260, 1, -12)
    toast.BackgroundColor3 = Color3.fromRGB(10, 11, 17)
    toast.BorderSizePixel = 0
    toast.ZIndex = 100
    toast.Parent = tab
    corner(toast, 11)

    local toastStroke = stroke(toast, 0.4, 1)
    toastStroke.ZIndex = 101

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, -14)
    accent.Position = UDim2.new(0, 8, 0, 7)
    accent.BackgroundColor3 = getTheme()
    accent.BorderSizePixel = 0
    accent.ZIndex = 102
    accent.Parent = toast
    corner(accent, 2)

    local textLabel = label(toast, tostring(text), 9,
        Color3.fromRGB(235, 237, 244), Enum.Font.GothamBold)
    textLabel.Position = UDim2.new(0, 21, 0, 0)
    textLabel.Size = UDim2.new(1, -30, 1, 0)
    textLabel.ZIndex = 102

    tween(toast, {Position = UDim2.new(1, -12, 1, -12)}, 0.28):Play()

    task.delay(2.2, function()
        if not toast.Parent then return end
        tween(toast, {Position = UDim2.new(1, 260, 1, -12)}, 0.25):Play()
        task.wait(0.3)
        if toast.Parent then toast:Destroy() end
    end)
end

local function resolveLoader(key)
    if context then
        if type(context.LoadFunction) == "function" then
            return function() return context.LoadFunction(key) end
        end
        if type(context.Navigate) == "function" then
            return function() return context.Navigate(key) end
        end
    end

    if main then
        local event = main:FindFirstChild("Navigate")
        if event and event:IsA("BindableEvent") then
            return function() event:Fire(key) end
        end
    end

    return nil
end

--========================================================
-- PREMIUM CARD
-- No circular hover bubble. Uses a slim rectangular sheen,
-- border pulse, icon lift and arrow motion instead.
--========================================================
local function makeCard(data, order)
    local card = Instance.new("TextButton")
    card.Name = data.key .. "Card"
    card.LayoutOrder = order
    card.AutoButtonColor = false
    card.Text = ""
    card.Size = UDim2.new(1, 0, 0, 104)
    card.BackgroundColor3 = Color3.fromRGB(9, 10, 15)
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = root
    corner(card, 13)

    local cardStroke = stroke(card, 0.68, 1)
    table.insert(strokeObjects, cardStroke)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 9, 14)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(14, 16, 24)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(12, 14, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 9, 14))
    })
    gradient.Rotation = 0
    gradient.Parent = card

    local sheen = Instance.new("Frame")
    sheen.Name = "HoverSheen"
    sheen.Size = UDim2.new(0, 80, 1, 0)
    sheen.Position = UDim2.new(0, -100, 0, 0)
    sheen.BackgroundColor3 = getTheme()
    sheen.BackgroundTransparency = 0.94
    sheen.BorderSizePixel = 0
    sheen.Rotation = 0
    sheen.ZIndex = 1
    sheen.Parent = card

    local sheenGradient = Instance.new("UIGradient")
    sheenGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.15),
        NumberSequenceKeypoint.new(1, 1)
    })
    sheenGradient.Parent = sheen

    local indicator = Instance.new("Frame")
    indicator.Name = "Accent"
    indicator.Size = UDim2.new(0, 4, 0, 58)
    indicator.Position = UDim2.new(0, 11, 0.5, -29)
    indicator.BackgroundColor3 = getTheme()
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 3
    indicator.Parent = card
    corner(indicator, 3)
    table.insert(accentObjects, indicator)

    local iconBox = Instance.new("Frame")
    iconBox.Name = "Icon"
    iconBox.Size = UDim2.new(0, 38, 0, 38)
    iconBox.Position = UDim2.new(0, 23, 0, 15)
    iconBox.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
    iconBox.BackgroundTransparency = 0.12
    iconBox.BorderSizePixel = 0
    iconBox.ZIndex = 3
    iconBox.Parent = card
    corner(iconBox, 10)

    local iconStroke = stroke(iconBox, 0.55, 1)
    table.insert(strokeObjects, iconStroke)

    local icon = label(iconBox, data.icon, 14, getTheme(), Enum.Font.GothamBold)
    icon.Size = UDim2.fromScale(1, 1)
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.ZIndex = 4
    table.insert(accentLabels, icon)

    local name = label(card, data.name, 11,
        Color3.fromRGB(240, 242, 248), Enum.Font.GothamBold)
    name.Position = UDim2.new(0, 72, 0, 13)
    name.Size = UDim2.new(1, -116, 0, 21)
    name.TextSize = 11
    name.ZIndex = 4

    local desc = label(card, data.desc, 8,
        Color3.fromRGB(125, 130, 145), Enum.Font.GothamMedium)
    desc.Position = UDim2.new(0, 72, 0, 38)
    desc.Size = UDim2.new(1, -112, 0, 30)
    desc.TextWrapped = true
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.ZIndex = 4

    local arrow = label(card, "›", 22, getTheme(), Enum.Font.GothamBold)
    arrow.Position = UDim2.new(1, -34, 0.5, -13)
    arrow.Size = UDim2.new(0, 22, 0, 26)
    arrow.TextXAlignment = Enum.TextXAlignment.Center
    arrow.ZIndex = 4
    table.insert(accentLabels, arrow)

    local bottomLine = Instance.new("Frame")
    bottomLine.Name = "BottomAccent"
    bottomLine.Size = UDim2.new(1, -100, 0, 1)
    bottomLine.Position = UDim2.new(0, 72, 1, -12)
    bottomLine.BackgroundColor3 = getTheme()
    bottomLine.BackgroundTransparency = 0.80
    bottomLine.BorderSizePixel = 0
    bottomLine.ZIndex = 4
    bottomLine.Parent = card
    table.insert(accentObjects, bottomLine)

    local cardScale = Instance.new("UIScale")
    cardScale.Name = "CardScale"
    cardScale.Scale = 1
    cardScale.Parent = card

    cards[#cards + 1] = {
        card = card,
        name = name,
        desc = desc,
        data = data
    }

    local baseColor = card.BackgroundColor3

    card.MouseEnter:Connect(function()
        tween(card, {
            BackgroundColor3 = Color3.fromRGB(16, 18, 27)
        }, 0.16):Play()

        tween(cardStroke, {
            Transparency = 0.10,
            Thickness = 1.35
        }, 0.16):Play()

        tween(cardScale, {Scale = 1.018}, 0.18):Play()
        tween(iconBox, {
            BackgroundTransparency = 0,
            Position = UDim2.new(0, 25, 0, 14)
        }, 0.16):Play()

        tween(arrow, {
            Position = UDim2.new(1, -28, 0.5, -13)
        }, 0.16):Play()

        tween(indicator, {
            Size = UDim2.new(0, 5, 0, 70),
            Position = UDim2.new(0, 10, 0.5, -35)
        }, 0.16):Play()

        tween(sheen, {
            Position = UDim2.new(1, 18, 0, 0),
            BackgroundTransparency = 0.90
        }, 0.42):Play()
    end)

    card.MouseLeave:Connect(function()
        tween(card, {BackgroundColor3 = baseColor}, 0.16):Play()
        tween(cardStroke, {Transparency = 0.68, Thickness = 1}, 0.16):Play()
        tween(cardScale, {Scale = 1}, 0.18):Play()

        tween(iconBox, {
            BackgroundTransparency = 0.12,
            Position = UDim2.new(0, 23, 0, 15)
        }, 0.16):Play()

        tween(arrow, {
            Position = UDim2.new(1, -34, 0.5, -13)
        }, 0.16):Play()

        tween(indicator, {
            Size = UDim2.new(0, 4, 0, 58),
            Position = UDim2.new(0, 11, 0.5, -29)
        }, 0.16):Play()

        tween(sheen, {
            Position = UDim2.new(0, -100, 0, 0),
            BackgroundTransparency = 0.94
        }, 0.22):Play()
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

for index, data in ipairs(modules) do
    makeCard(data, index)
end

--========================================================
-- SEARCH FILTER
--========================================================
box:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(box.Text or "")
    clearButton.Visible = query ~= ""

    local visibleCount = 0

    for _, item in ipairs(cards) do
        local nameText = string.lower(item.name.Text)
        local descriptionText = string.lower(item.desc.Text)

        local visible =
            query == ""
            or string.find(nameText, query, 1, true) ~= nil
            or string.find(descriptionText, query, 1, true) ~= nil

        item.card.Visible = visible
        if visible then
            visibleCount += 1
        end
    end

    count.Text = query == ""
        and "07 MODULES"
        or string.format("%02d FOUND", visibleCount)
end)

--========================================================
-- THEME SYNC
--========================================================
task.spawn(function()
    local pulse = 0

    while tab.Parent do
        local color = getTheme()
        pulse = (pulse + 0.035) % (math.pi * 2)

        for _, object in ipairs(accentObjects) do
            if object and object.Parent then
                object.BackgroundColor3 = color
            end
        end

        for _, object in ipairs(accentLabels) do
            if object and object.Parent then
                object.TextColor3 = color
            end
        end

        for _, object in ipairs(strokeObjects) do
            if object and object.Parent then
                object.Color = color
            end
        end

        if headerGlow.Parent then
            headerGlow.BackgroundTransparency = 0.90 + math.sin(pulse) * 0.025
        end

        if statusDot.Parent then
            statusDot.BackgroundTransparency =
                0.15 + math.abs(math.sin(pulse)) * 0.35
        end

        task.wait(0.08)
    end
end)

--========================================================
-- ENTRY ANIMATION
--========================================================
task.spawn(function()
    local objects = {}

    for _, child in ipairs(root:GetChildren()) do
        if child:IsA("GuiObject") then
            objects[#objects + 1] = child
        end
    end

    for _, child in ipairs(objects) do
        child.Position = child.Position + UDim2.fromOffset(0, 8)
        child.BackgroundTransparency =
            math.clamp(child.BackgroundTransparency + 0.15, 0, 1)
    end

    task.wait(0.04)

    for index, child in ipairs(objects) do
        task.delay((index - 1) * 0.035, function()
            if not child.Parent then return end

            local target = child.Position - UDim2.fromOffset(0, 8)
            tween(child, {
                Position = target,
                BackgroundTransparency = 0
            }, 0.32):Play()
        end)
    end
end)
