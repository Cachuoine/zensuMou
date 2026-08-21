--// FishHub • Function.lua
--// Clean premium Function tab
--// No circular glow bubbles.
--// Search is the only header control: full-width horizontal bar.
--// Module cards remain 2-column and keep their loading hooks.

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

tab.BackgroundTransparency = 1
tab.BorderSizePixel = 0
tab.ScrollBarThickness = 0
tab.ScrollBarImageTransparency = 1
tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
tab.ClipsDescendants = true

local function theme()
    local s = main and main:FindFirstChildOfClass("UIStroke")
    return s and s.Color or Color3.fromRGB(0, 229, 255)
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function mkStroke(parent, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = theme()
    s.Thickness = thickness or 1
    s.Transparency = transparency or .6
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
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

local function tween(obj, props, duration)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(duration or .2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    )
    t:Play()
    return t
end

local accents = {}
local strokes = {}
local accentTexts = {}
local cards = {}

--========================================================
-- ROOT
--========================================================
local scroll = Instance.new("ScrollingFrame")
scroll.Name = "FunctionScroll"
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 0
scroll.ScrollBarImageTransparency = 1
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new()
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.Parent = tab

local root = Instance.new("Frame")
root.Name = "FunctionContent"
root.Size = UDim2.new(1, -14, 0, 0)
root.Position = UDim2.new(0, 7, 0, 0)
root.AutomaticSize = Enum.AutomaticSize.Y
root.BackgroundTransparency = 1
root.Parent = scroll

local rootPad = Instance.new("UIPadding")
rootPad.PaddingTop = UDim.new(0, 7)
rootPad.PaddingBottom = UDim.new(0, 18)
rootPad.Parent = root

local rootList = Instance.new("UIListLayout")
rootList.FillDirection = Enum.FillDirection.Vertical
rootList.HorizontalAlignment = Enum.HorizontalAlignment.Center
rootList.SortOrder = Enum.SortOrder.LayoutOrder
rootList.Padding = UDim.new(0, 10)
rootList.Parent = root

--========================================================
-- SEARCH ONLY
-- No "FUNCTION" header box. No circular search glow.
--========================================================
local search = Instance.new("Frame")
search.Name = "FunctionSearch"
search.LayoutOrder = 1
search.Size = UDim2.new(1, 0, 0, 42)
search.BackgroundColor3 = Color3.fromRGB(8, 9, 14)
search.BorderSizePixel = 0
search.Parent = root
corner(search, 11)

local searchStroke = mkStroke(search, .55, 1)
table.insert(strokes, searchStroke)

local iconHolder = Instance.new("Frame")
iconHolder.Name = "SearchIcon"
iconHolder.Size = UDim2.new(0, 30, 0, 30)
iconHolder.Position = UDim2.new(0, 9, .5, -15)
iconHolder.BackgroundTransparency = 1
iconHolder.Parent = search

local lens = Instance.new("Frame")
lens.Size = UDim2.new(0, 13, 0, 13)
lens.Position = UDim2.new(0, 4, 0, 4)
lens.BackgroundTransparency = 1
lens.BorderSizePixel = 0
lens.Parent = iconHolder
corner(lens, 20)

local lensStroke = Instance.new("UIStroke")
lensStroke.Color = theme()
lensStroke.Thickness = 2
lensStroke.Parent = lens
table.insert(strokes, lensStroke)

local handle = Instance.new("Frame")
handle.Size = UDim2.new(0, 8, 0, 2)
handle.Position = UDim2.new(0, 16, 0, 18)
handle.Rotation = 45
handle.AnchorPoint = Vector2.new(0, .5)
handle.BackgroundColor3 = theme()
handle.BorderSizePixel = 0
handle.Parent = iconHolder
corner(handle, 2)
table.insert(accents, handle)

local box = Instance.new("TextBox")
box.Name = "SearchBox"
box.Size = UDim2.new(1, -25, 1, 0)
box.Position = UDim2.new(0, 43, 0, 0)
box.BackgroundTransparency = 1
box.ClearTextOnFocus = false
box.Text = ""
box.PlaceholderText = "search..."
box.PlaceholderColor3 = Color3.fromRGB(120, 124, 138)
box.TextColor3 = Color3.fromRGB(235, 237, 244)
box.TextSize = 10
box.Font = Enum.Font.GothamMedium
box.TextXAlignment = Enum.TextXAlignment.Left
box.Parent = search

box.Focused:Connect(function()
    tween(searchStroke, {Transparency = .08, Thickness = 1.25}, .18)
end)

box.FocusLost:Connect(function()
    tween(searchStroke, {Transparency = .55, Thickness = 1}, .18)
end)

--========================================================
-- MODULE GRID
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

local gridHolder = Instance.new("Frame")
gridHolder.Name = "ModuleGridHolder"
gridHolder.LayoutOrder = 2
gridHolder.Size = UDim2.new(1, 0, 0, 0)
gridHolder.AutomaticSize = Enum.AutomaticSize.Y
gridHolder.BackgroundTransparency = 1
gridHolder.Parent = root

local grid = Instance.new("UIGridLayout")
grid.Name = "ModuleGrid"
grid.CellSize = UDim2.new(.5, -5, 0, 104)
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.FillDirection = Enum.FillDirection.Horizontal
grid.FillDirectionMaxCells = 2
grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.Parent = gridHolder

local function notify(text)
    if context and type(context.ShowNotification) == "function" then
        pcall(context.ShowNotification, tostring(text))
    end
end

local function openModule(key, displayName)
    if context and type(context.LoadFunction) == "function" then
        local ok, err = pcall(context.LoadFunction, key)
        if not ok then
            warn("[FishHub] " .. tostring(err))
            notify("Failed to open " .. displayName)
        end
        return
    end

    if context and type(context.Navigate) == "function" then
        local ok, err = pcall(context.Navigate, key)
        if not ok then
            warn("[FishHub] " .. tostring(err))
            notify("Failed to open " .. displayName)
        end
        return
    end

    if main then
        local event = main:FindFirstChild("Navigate")
        if event and event:IsA("BindableEvent") then
            event:Fire(key)
            return
        end
    end

    notify(displayName .. " selected")
end

local function makeCard(data, order)
    local card = Instance.new("TextButton")
    card.Name = data.key .. "Card"
    card.LayoutOrder = order
    card.Size = UDim2.new(1, 0, 0, 104)
    card.BackgroundColor3 = Color3.fromRGB(9, 10, 15)
    card.BorderSizePixel = 0
    card.AutoButtonColor = false
    card.Text = ""
    card.ClipsDescendants = true
    card.Parent = gridHolder
    corner(card, 13)

    local cardStroke = mkStroke(card, .68, 1)
    table.insert(strokes, cardStroke)

    -- Rectangular sheen only. No circles.
    local sheen = Instance.new("Frame")
    sheen.Name = "HoverSheen"
    sheen.Size = UDim2.new(0, 70, 1, 0)
    sheen.Position = UDim2.new(0, -90, 0, 0)
    sheen.BackgroundColor3 = theme()
    sheen.BackgroundTransparency = .94
    sheen.BorderSizePixel = 0
    sheen.ZIndex = 1
    sheen.Parent = card

    local sheenGradient = Instance.new("UIGradient")
    sheenGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(.5, .15),
        NumberSequenceKeypoint.new(1, 1)
    })
    sheenGradient.Parent = sheen

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 4, 0, 58)
    indicator.Position = UDim2.new(0, 10, .5, -29)
    indicator.BackgroundColor3 = theme()
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 3
    indicator.Parent = card
    corner(indicator, 3)
    table.insert(accents, indicator)

    local iconBox = Instance.new("Frame")
    iconBox.Size = UDim2.new(0, 38, 0, 38)
    iconBox.Position = UDim2.new(0, 22, 0, 14)
    iconBox.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
    iconBox.BackgroundTransparency = .12
    iconBox.BorderSizePixel = 0
    iconBox.ZIndex = 3
    iconBox.Parent = card
    corner(iconBox, 10)

    local iconStroke = mkStroke(iconBox, .55, 1)
    table.insert(strokes, iconStroke)

    local icon = label(iconBox, data.icon, 14, theme(), Enum.Font.GothamBold)
    icon.Size = UDim2.fromScale(1, 1)
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.ZIndex = 4
    table.insert(accentTexts, icon)

    local name = label(card, data.name, 11,
        Color3.fromRGB(240, 242, 248), Enum.Font.GothamBold)
    name.Position = UDim2.new(0, 70, 0, 12)
    name.Size = UDim2.new(1, -108, 0, 22)
    name.ZIndex = 4

    local desc = label(card, data.desc, 8,
        Color3.fromRGB(125, 130, 145), Enum.Font.GothamMedium)
    desc.Position = UDim2.new(0, 70, 0, 37)
    desc.Size = UDim2.new(1, -102, 0, 30)
    desc.TextWrapped = true
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.ZIndex = 4

    local arrow = label(card, "›", 22, theme(), Enum.Font.GothamBold)
    arrow.Position = UDim2.new(1, -34, .5, -13)
    arrow.Size = UDim2.new(0, 22, 0, 26)
    arrow.TextXAlignment = Enum.TextXAlignment.Center
    arrow.ZIndex = 4
    table.insert(accentTexts, arrow)

    local bottom = Instance.new("Frame")
    bottom.Size = UDim2.new(1, -90, 0, 1)
    bottom.Position = UDim2.new(0, 70, 1, -12)
    bottom.BackgroundColor3 = theme()
    bottom.BackgroundTransparency = .82
    bottom.BorderSizePixel = 0
    bottom.ZIndex = 4
    bottom.Parent = card
    table.insert(accents, bottom)

    local scale = Instance.new("UIScale")
    scale.Scale = 1
    scale.Parent = card

    local baseColor = card.BackgroundColor3
    local baseIconPos = iconBox.Position

    card.MouseEnter:Connect(function()
        tween(card, {BackgroundColor3 = Color3.fromRGB(16, 18, 27)}, .16)
        tween(cardStroke, {Transparency = .10, Thickness = 1.3}, .16)
        tween(scale, {Scale = 1.018}, .18)
        tween(iconBox, {
            Position = baseIconPos + UDim2.fromOffset(2, -1),
            BackgroundTransparency = 0
        }, .16)
        tween(arrow, {Position = UDim2.new(1, -28, .5, -13)}, .16)
        tween(indicator, {
            Size = UDim2.new(0, 5, 0, 70),
            Position = UDim2.new(0, 9, .5, -35)
        }, .16)
        tween(sheen, {
            Position = UDim2.new(1, 15, 0, 0),
            BackgroundTransparency = .90
        }, .40)
    end)

    card.MouseLeave:Connect(function()
        tween(card, {BackgroundColor3 = baseColor}, .16)
        tween(cardStroke, {Transparency = .68, Thickness = 1}, .16)
        tween(scale, {Scale = 1}, .18)
        tween(iconBox, {
            Position = baseIconPos,
            BackgroundTransparency = .12
        }, .16)
        tween(arrow, {Position = UDim2.new(1, -34, .5, -13)}, .16)
        tween(indicator, {
            Size = UDim2.new(0, 4, 0, 58),
            Position = UDim2.new(0, 10, .5, -29)
        }, .16)
        tween(sheen, {
            Position = UDim2.new(0, -90, 0, 0),
            BackgroundTransparency = .94
        }, .22)
    end)

    card.Activated:Connect(function()
        openModule(data.key, data.name)
    end)

    cards[#cards + 1] = {
        card = card,
        name = name,
        desc = desc,
        data = data
    }
end

for i, data in ipairs(modules) do
    makeCard(data, i)
end

--========================================================
-- SEARCH FILTER
--========================================================
box:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(box.Text or "")

    for _, item in ipairs(cards) do
        local n = string.lower(item.name.Text)
        local d = string.lower(item.desc.Text)

        item.card.Visible =
            query == ""
            or string.find(n, query, 1, true) ~= nil
            or string.find(d, query, 1, true) ~= nil
    end
end)

--========================================================
-- FISHHUB CREATIVE FOOTER
-- Same divider style used by the Creative section.
--========================================================
local footer = Instance.new("Frame")
footer.Name = "FishHubCreativeFooter"
footer.LayoutOrder = 3
footer.Size = UDim2.new(1, 34, 0, 42)
footer.Position = UDim2.new(0, -17, 0, 0)
footer.BackgroundTransparency = 1
footer.Parent = root

local footerTitle = label(
    footer,
    "FISHHUB CREATIVE",
    9,
    theme(),
    Enum.Font.GothamBold
)
footerTitle.Size = UDim2.new(0, 190, 0, 18)
footerTitle.Position = UDim2.new(.5, -95, 0, 0)
footerTitle.TextXAlignment = Enum.TextXAlignment.Center
table.insert(accentTexts, footerTitle)

local footerLine = Instance.new("Frame")
footerLine.Name = "FooterLine"
footerLine.Size = UDim2.new(1, 0, 0, 1)
footerLine.Position = UDim2.new(0, 0, 0, 25)
footerLine.BackgroundColor3 = theme()
footerLine.BorderSizePixel = 0
footerLine.Parent = footer
table.insert(accents, footerLine)

local footerGradient = Instance.new("UIGradient")
footerGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, .98),
    NumberSequenceKeypoint.new(.16, .68),
    NumberSequenceKeypoint.new(.35, .20),
    NumberSequenceKeypoint.new(.50, 0),
    NumberSequenceKeypoint.new(.65, .20),
    NumberSequenceKeypoint.new(.84, .68),
    NumberSequenceKeypoint.new(1, .98)
})
footerGradient.Parent = footerLine

--========================================================
-- THEME SYNC
--========================================================
task.spawn(function()
    while tab.Parent do
        local color = theme()

        for _, object in ipairs(accents) do
            if object and object.Parent then
                object.BackgroundColor3 = color
            end
        end

        for _, object in ipairs(accentTexts) do
            if object and object.Parent then
                object.TextColor3 = color
            end
        end

        for _, object in ipairs(strokes) do
            if object and object.Parent then
                object.Color = color
            end
        end

        task.wait(.08)
    end
end)

--========================================================
-- ENTRY ANIMATION
--========================================================
task.spawn(function()
    task.wait(.03)

    for _, object in ipairs(cards) do
        local card = object.card
        card.Position = card.Position + UDim2.fromOffset(0, 7)
        task.delay(object.data and table.find(modules, object.data) * .025 or 0, function()
            if card.Parent then
                tween(card, {Position = card.Position - UDim2.fromOffset(0, 7)}, .28)
            end
        end)
    end
end)
