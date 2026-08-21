-- FishHub • Function.lua
-- Fixed horizontal search bar + 2-column module cards

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player then return end

local context = ...
local playerGui = context and context.PlayerGui or player:WaitForChild("PlayerGui", 10)
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

for _, child in ipairs(tab:GetChildren()) do child:Destroy() end
tab.ClipsDescendants = true

local function theme()
    local stroke = main and main:FindFirstChildOfClass("UIStroke")
    return stroke and stroke.Color or Color3.fromRGB(104, 82, 255)
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

local function addStroke(parent, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = theme()
    s.Thickness = thickness or 1
    s.Transparency = transparency or .55
    s.Parent = parent
    return s
end

local function label(parent, text, size, color, font)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Text = text
    x.TextSize = size
    x.TextColor3 = color
    x.Font = font or Enum.Font.GothamMedium
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.TextYAlignment = Enum.TextYAlignment.Center
    x.Parent = parent
    return x
end

local function tween(object, properties, duration)
    local t = TweenService:Create(
        object,
        TweenInfo.new(duration or .2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        properties
    )
    t:Play()
    return t
end

local root = Instance.new("Frame")
root.Name = "FunctionRoot"
root.Size = UDim2.fromScale(1, 1)
root.BackgroundTransparency = 1
root.Parent = tab

local header = Instance.new("Frame")
header.Name = "FunctionHeader"
header.Position = UDim2.new(0, 7, 0, 7)
header.Size = UDim2.new(1, -14, 0, 72)
header.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
header.BorderSizePixel = 0
header.ZIndex = 10
header.Parent = root
corner(header, 14)
local headerStroke = addStroke(header, .35, 1.2)

local accent = Instance.new("Frame")
accent.Size = UDim2.new(0, 4, 1, -26)
accent.Position = UDim2.new(0, 13, 0, 13)
accent.BackgroundColor3 = theme()
accent.BorderSizePixel = 0
accent.ZIndex = 12
accent.Parent = header
corner(accent, 3)

local title = label(header, "FUNCTION", 18, Color3.fromRGB(245, 246, 252), Enum.Font.GothamBlack)
title.Position = UDim2.new(0, 27, 0, 9)
title.Size = UDim2.new(1, -45, 0, 24)
title.ZIndex = 12

local subtitle = label(header, "TOOLS  •  MODULES  •  UTILITIES", 8, Color3.fromRGB(125, 130, 145), Enum.Font.Code)
subtitle.Position = UDim2.new(0, 28, 0, 35)
subtitle.Size = UDim2.new(1, -45, 0, 15)
subtitle.ZIndex = 12

local moduleCount = label(header, "07 MODULES", 8, theme(), Enum.Font.GothamBold)
moduleCount.Position = UDim2.new(1, -96, 0, 11)
moduleCount.Size = UDim2.new(0, 80, 0, 17)
moduleCount.TextXAlignment = Enum.TextXAlignment.Right
moduleCount.ZIndex = 12

local status = label(header, "READY", 7, Color3.fromRGB(110, 115, 130), Enum.Font.Code)
status.Position = UDim2.new(1, -96, 0, 35)
status.Size = UDim2.new(0, 80, 0, 15)
status.TextXAlignment = Enum.TextXAlignment.Right
status.ZIndex = 12

-- Fixed search: it is outside the scrolling frame.
local searchWrap = Instance.new("Frame")
searchWrap.Name = "FixedSearchBar"
searchWrap.Position = UDim2.new(0, 7, 0, 87)
searchWrap.Size = UDim2.new(1, -14, 0, 44)
searchWrap.BackgroundColor3 = Color3.fromRGB(9, 10, 16)
searchWrap.BorderSizePixel = 0
searchWrap.ZIndex = 20
searchWrap.Parent = root
corner(searchWrap, 12)
local searchStroke = addStroke(searchWrap, .58, 1)

local iconHolder = Instance.new("Frame")
iconHolder.Size = UDim2.fromOffset(34, 34)
iconHolder.Position = UDim2.new(0, 8, .5, -17)
iconHolder.BackgroundTransparency = 1
iconHolder.ZIndex = 22
iconHolder.Parent = searchWrap

local lens = Instance.new("Frame")
lens.Size = UDim2.fromOffset(14, 14)
lens.Position = UDim2.fromOffset(5, 4)
lens.BackgroundTransparency = 1
lens.BorderSizePixel = 0
lens.ZIndex = 23
lens.Parent = iconHolder
corner(lens, 20)

local lensStroke = Instance.new("UIStroke")
lensStroke.Color = theme()
lensStroke.Thickness = 2
lensStroke.Parent = lens

local handle = Instance.new("Frame")
handle.Size = UDim2.fromOffset(8, 2)
handle.Position = UDim2.fromOffset(18, 18)
handle.AnchorPoint = Vector2.new(0, .5)
handle.Rotation = 45
handle.BackgroundColor3 = theme()
handle.BorderSizePixel = 0
handle.ZIndex = 23
handle.Parent = iconHolder
corner(handle, 2)

local search = Instance.new("TextBox")
search.Name = "SearchBox"
search.Position = UDim2.new(0, 48, 0, 0)
search.Size = UDim2.new(1, -58, 1, 0)
search.BackgroundTransparency = 1
search.BorderSizePixel = 0
search.Font = Enum.Font.GothamMedium
search.TextSize = 10
search.TextColor3 = Color3.fromRGB(235, 238, 245)
search.PlaceholderColor3 = Color3.fromRGB(100, 105, 120)
search.PlaceholderText = "Search functions..."
search.Text = ""
search.ClearTextOnFocus = false
search.TextXAlignment = Enum.TextXAlignment.Left
search.ZIndex = 22
search.Parent = searchWrap

search.Focused:Connect(function()
    tween(searchStroke, {Transparency = .05, Thickness = 1.3}, .18)
end)

search.FocusLost:Connect(function()
    tween(searchStroke, {Transparency = .58, Thickness = 1}, .18)
end)

local cardsScroll = Instance.new("ScrollingFrame")
cardsScroll.Name = "FunctionCardsScroll"
cardsScroll.Position = UDim2.new(0, 7, 0, 140)
cardsScroll.Size = UDim2.new(1, -14, 1, -147)
cardsScroll.BackgroundTransparency = 1
cardsScroll.BorderSizePixel = 0
cardsScroll.ScrollBarThickness = 0
cardsScroll.ScrollBarImageTransparency = 1
cardsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
cardsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
cardsScroll.CanvasSize = UDim2.new()
cardsScroll.ZIndex = 2
cardsScroll.Parent = root

local cardPadding = Instance.new("UIPadding")
cardPadding.PaddingTop = UDim.new(0, 4)
cardPadding.PaddingBottom = UDim.new(0, 12)
cardPadding.PaddingLeft = UDim.new(0, 2)
cardPadding.PaddingRight = UDim.new(0, 2)
cardPadding.Parent = cardsScroll

local gridHolder = Instance.new("Frame")
gridHolder.Name = "ModuleGrid"
gridHolder.Size = UDim2.new(1, -4, 0, 0)
gridHolder.AutomaticSize = Enum.AutomaticSize.Y
gridHolder.BackgroundTransparency = 1
gridHolder.Parent = cardsScroll

local grid = Instance.new("UIGridLayout")
grid.Name = "FunctionGrid"
grid.CellSize = UDim2.new(.5, -6, 0, 96)
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.FillDirection = Enum.FillDirection.Horizontal
grid.FillDirectionMaxCells = 2
grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.Parent = gridHolder

local modules = {
    {name = "SHOP", key = "Shop", description = "Open shop utilities and item controls.", icon = "S"},
    {name = "SETTING FARM", key = "SettingFarm", description = "Configure farming preferences and behavior.", icon = "F"},
    {name = "FARM", key = "Farm", description = "Access farming functions and automation.", icon = "A"},
    {name = "ITEM & QUEST", key = "ItemQuest", description = "Items, quests and related utilities.", icon = "Q"},
    {name = "ISLAND", key = "Island", description = "Island navigation and travel functions.", icon = "I"},
    {name = "FRUIT", key = "Fruit", description = "Fruit utilities, controls and helpers.", icon = "F"},
    {name = "SETTING", key = "Setting", description = "Open FishHub settings and interface controls.", icon = "G"}
}

local cards = {}

local function notify(text)
    if context and type(context.ShowNotification) == "function" then
        pcall(context.ShowNotification, text)
    else
        warn("[FishHub] " .. tostring(text))
    end
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
end

local function createCard(data, order)
    local card = Instance.new("TextButton")
    card.Name = data.key .. "Card"
    card.LayoutOrder = order
    card.Size = UDim2.new(1, 0, 0, 96)
    card.BackgroundColor3 = Color3.fromRGB(8, 9, 14)
    card.BorderSizePixel = 0
    card.AutoButtonColor = false
    card.Text = ""
    card.ClipsDescendants = true
    card.ZIndex = 3
    card.Parent = gridHolder
    corner(card, 14)

    local cardStroke = addStroke(card, .65, 1)
    cardStroke.ZIndex = 4

    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(0, 4, 0, 56)
    accentLine.Position = UDim2.new(0, 10, .5, -28)
    accentLine.BackgroundColor3 = theme()
    accentLine.BorderSizePixel = 0
    accentLine.ZIndex = 5
    accentLine.Parent = card
    corner(accentLine, 4)

    local iconBox = Instance.new("Frame")
    iconBox.Size = UDim2.fromOffset(36, 36)
    iconBox.Position = UDim2.fromOffset(22, 13)
    iconBox.BackgroundColor3 = Color3.fromRGB(17, 19, 28)
    iconBox.BorderSizePixel = 0
    iconBox.ZIndex = 5
    iconBox.Parent = card
    corner(iconBox, 10)

    local iconStroke = addStroke(iconBox, .52, 1)
    iconStroke.ZIndex = 6

    local icon = label(iconBox, data.icon, 13, theme(), Enum.Font.GothamBlack)
    icon.Size = UDim2.fromScale(1, 1)
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.ZIndex = 7

    local name = label(card, data.name, 10, Color3.fromRGB(242, 244, 250), Enum.Font.GothamBold)
    name.Position = UDim2.fromOffset(70, 11)
    name.Size = UDim2.new(1, -104, 0, 21)
    name.ZIndex = 6

    local description = label(card, data.description, 8, Color3.fromRGB(125, 130, 145), Enum.Font.GothamMedium)
    description.Position = UDim2.fromOffset(70, 34)
    description.Size = UDim2.new(1, -104, 0, 34)
    description.TextWrapped = true
    description.TextYAlignment = Enum.TextYAlignment.Top
    description.ZIndex = 6

    local arrow = label(card, "›", 22, theme(), Enum.Font.GothamBold)
    arrow.Position = UDim2.new(1, -31, .5, -12)
    arrow.Size = UDim2.fromOffset(20, 24)
    arrow.TextXAlignment = Enum.TextXAlignment.Center
    arrow.ZIndex = 7

    local bottomLine = Instance.new("Frame")
    bottomLine.Size = UDim2.new(1, -92, 0, 1)
    bottomLine.Position = UDim2.new(0, 70, 1, -10)
    bottomLine.BackgroundColor3 = theme()
    bottomLine.BackgroundTransparency = .82
    bottomLine.BorderSizePixel = 0
    bottomLine.ZIndex = 5
    bottomLine.Parent = card

    table.insert(cards, {
        card = card,
        name = name,
        description = description,
        data = data,
        accent = accentLine,
        arrow = arrow,
        stroke = cardStroke
    })

    card.MouseEnter:Connect(function()
        tween(card, {BackgroundColor3 = Color3.fromRGB(16, 18, 27)}, .16)
        tween(cardStroke, {Color = theme(), Transparency = .08, Thickness = 1.35}, .16)
        tween(iconBox, {BackgroundColor3 = Color3.fromRGB(25, 27, 40)}, .16)
        tween(arrow, {Position = UDim2.new(1, -27, .5, -12)}, .16)
        tween(accentLine, {
            Size = UDim2.new(0, 5, 0, 68),
            Position = UDim2.new(0, 9, .5, -34)
        }, .16)
    end)

    card.MouseLeave:Connect(function()
        tween(card, {BackgroundColor3 = Color3.fromRGB(8, 9, 14)}, .16)
        tween(cardStroke, {Color = theme(), Transparency = .65, Thickness = 1}, .16)
        tween(iconBox, {BackgroundColor3 = Color3.fromRGB(17, 19, 28)}, .16)
        tween(arrow, {Position = UDim2.new(1, -31, .5, -12)}, .16)
        tween(accentLine, {
            Size = UDim2.new(0, 4, 0, 56),
            Position = UDim2.new(0, 10, .5, -28)
        }, .16)
    end)

    card.Activated:Connect(function()
        local loader = resolveLoader(data.key)
        if loader then
            local ok, err = pcall(loader)
            if not ok then
                notify("Failed to open " .. data.name)
                warn("[FishHub] " .. tostring(err))
            end
        else
            notify(data.name .. " selected")
        end
    end)
end

for index, data in ipairs(modules) do
    createCard(data, index)
end

search:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(search.Text or "")
    local found = 0

    for _, item in ipairs(cards) do
        local nameText = string.lower(item.name.Text)
        local descText = string.lower(item.description.Text)
        local visible = query == ""
            or string.find(nameText, query, 1, true) ~= nil
            or string.find(descText, query, 1, true) ~= nil

        item.card.Visible = visible
        if visible then found += 1 end
    end

    moduleCount.Text = query == "" and "07 MODULES" or string.format("%02d FOUND", found)
end)

task.spawn(function()
    while tab.Parent do
        local color = theme()
        accent.BackgroundColor3 = color
        moduleCount.TextColor3 = color
        lensStroke.Color = color
        handle.BackgroundColor3 = color

        for _, item in ipairs(cards) do
            item.accent.BackgroundColor3 = color
            item.arrow.TextColor3 = color
            item.stroke.Color = color
        end

        task.wait(.1)
    end
end)
