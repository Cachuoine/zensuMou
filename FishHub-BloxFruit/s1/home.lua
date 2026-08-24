local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")

local context = ...
local player = (context and context.Player) or Players.LocalPlayer
if not player then return end

local playerGui = (context and context.PlayerGui) or player:WaitForChild("PlayerGui", 10)
local tab = context and context.Tab
local main = context and context.MainWindow

if not tab then
    local fishHub = playerGui and playerGui:FindFirstChild("FishHub")
    local mainWindow = fishHub and fishHub:FindFirstChild("MainWindow")
    local content = mainWindow and mainWindow:FindFirstChild("ContentContainer")

    tab = content and content:FindFirstChild("HomeTab", true)
    main = main or mainWindow
end

if not tab then return end

for _, child in ipairs(tab:GetChildren()) do
    child:Destroy()
end

tab.ClipsDescendants = true

--//======================================================
--// THEME
--//======================================================

local function theme()
    local stroke = main and main:FindFirstChildOfClass("UIStroke")
    return stroke and stroke.Color or Color3.fromRGB(104, 82, 255)
end

local function darken(color, amount)
    return Color3.new(
        math.clamp(color.R - amount, 0, 1),
        math.clamp(color.G - amount, 0, 1),
        math.clamp(color.B - amount, 0, 1)
    )
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function addStroke(parent, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = theme()
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.55
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function addGradient(parent, colorA, colorB, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, colorA),
        ColorSequenceKeypoint.new(1, colorB)
    })
    g.Rotation = rotation or 0
    g.Parent = parent
    return g
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

local function tween(object, properties, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.25,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    return TweenService:Create(object, info, properties)
end

local dynamicLines = {}
local dynamicStrokes = {}
local dynamicAccents = {}
local dynamicText = {}

--//======================================================
--// SCROLL CONTAINER
--//======================================================

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "HomeScroll"
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.Position = UDim2.new()
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 0
scroll.ScrollBarImageTransparency = 1
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new()
scroll.ElasticBehavior = Enum.ElasticBehavior.Always
scroll.Parent = tab

local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 6)
pad.PaddingRight = UDim.new(0, 6)
pad.PaddingTop = UDim.new(0, 6)
pad.PaddingBottom = UDim.new(0, 14)
pad.Parent = scroll

local root = Instance.new("Frame")
root.Name = "HomeContent"
root.Size = UDim2.new(1, -12, 0, 0)
root.AutomaticSize = Enum.AutomaticSize.Y
root.BackgroundTransparency = 1
root.Parent = scroll

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 13)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = root

--//======================================================
--// WELCOME HERO
--//======================================================

local welcome = Instance.new("Frame")
welcome.Name = "WelcomeCard"
welcome.Size = UDim2.new(1, 0, 0, 126)
welcome.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
welcome.BorderSizePixel = 0
welcome.ClipsDescendants = true
welcome.Parent = root
corner(welcome, 15)

local welcomeStroke = addStroke(welcome, 0.35, 1)
table.insert(dynamicStrokes, welcomeStroke)

local heroGradient = addGradient(
    welcome,
    Color3.fromRGB(12, 13, 20),
    Color3.fromRGB(6, 7, 11),
    15
)

local heroGlow = Instance.new("Frame")
heroGlow.Name = "AccentGlow"
heroGlow.Size = UDim2.new(0, 150, 0, 150)
heroGlow.Position = UDim2.new(1, -90, 0, -70)
heroGlow.BackgroundColor3 = theme()
heroGlow.BackgroundTransparency = 0.86
heroGlow.BorderSizePixel = 0
heroGlow.Parent = welcome
corner(heroGlow, 100)

local glowGradient = Instance.new("UIGradient")
glowGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.05),
    NumberSequenceKeypoint.new(1, 1)
})
glowGradient.Parent = heroGlow

table.insert(dynamicAccents, heroGlow)

local accent = Instance.new("Frame")
accent.Name = "AccentBar"
accent.Size = UDim2.new(0, 4, 1, -34)
accent.Position = UDim2.new(0, 14, 0, 17)
accent.BackgroundColor3 = theme()
accent.BorderSizePixel = 0
accent.Parent = welcome
corner(accent, 4)
table.insert(dynamicAccents, accent)

local brand = label(
    welcome,
    "FISHHUB",
    22,
    Color3.fromRGB(245, 246, 252),
    Enum.Font.GothamBlack
)
brand.Position = UDim2.new(0, 31, 0, 13)
brand.Size = UDim2.new(1, -46, 0, 28)

local welcomeText = label(
    welcome,
    "WELCOME BACK",
    9,
    Color3.fromRGB(145, 150, 165),
    Enum.Font.GothamBold
)
welcomeText.Position = UDim2.new(0, 32, 0, 43)
welcomeText.Size = UDim2.new(1, -48, 0, 17)

local description = label(
    welcome,
    "Your control panel is ready.",
    10,
    Color3.fromRGB(184, 188, 200),
    Enum.Font.GothamMedium
)
description.Position = UDim2.new(0, 32, 0, 61)
description.Size = UDim2.new(1, -48, 0, 18)

local gameName = "Roblox"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then
        gameName = info.Name
    end
end)

local gamePill = Instance.new("Frame")
gamePill.Name = "GamePill"
gamePill.Size = UDim2.new(0, 0, 0, 25)
gamePill.AutomaticSize = Enum.AutomaticSize.X
gamePill.Position = UDim2.new(0, 31, 0, 91)
gamePill.BackgroundColor3 = Color3.fromRGB(13, 14, 21)
gamePill.BorderSizePixel = 0
gamePill.Parent = welcome
corner(gamePill, 8)
addStroke(gamePill, 0.78, 1)

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 6, 0, 6)
dot.Position = UDim2.new(0, 9, 0.5, -3)
dot.BackgroundColor3 = theme()
dot.BorderSizePixel = 0
dot.Parent = gamePill
corner(dot, 10)
table.insert(dynamicAccents, dot)

local gameTag = label(
    gamePill,
    "  " .. gameName,
    9,
    Color3.fromRGB(222, 224, 232),
    Enum.Font.GothamBold
)
gameTag.Size = UDim2.new(0, 0, 1, 0)
gameTag.AutomaticSize = Enum.AutomaticSize.X
gameTag.Position = UDim2.new(0, 17, 0, 0)

--//======================================================
--// SECTION BUILDER
--//======================================================

local function section(titleText, height)
    local holder = Instance.new("Frame")
    holder.Name = titleText:gsub("%s+", "")
    holder.Size = UDim2.new(1, 0, 0, height)
    holder.BackgroundTransparency = 1
    holder.Parent = root

    local title = label(
        holder,
        titleText,
        9,
        theme(),
        Enum.Font.GothamBold
    )
    title.Size = UDim2.new(0, 190, 0, 18)
    title.Position = UDim2.new(0.5, -95, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.ZIndex = 4
    table.insert(dynamicText, title)

    local line = Instance.new("Frame")
    line.Name = "SectionLine"
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0, 24)
    line.BackgroundColor3 = theme()
    line.BorderSizePixel = 0
    line.ZIndex = 1
    line.Parent = holder

    local lineGradient = Instance.new("UIGradient")
    lineGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.98),
        NumberSequenceKeypoint.new(0.14, 0.68),
        NumberSequenceKeypoint.new(0.35, 0.20),
        NumberSequenceKeypoint.new(0.50, 0),
        NumberSequenceKeypoint.new(0.65, 0.20),
        NumberSequenceKeypoint.new(0.86, 0.68),
        NumberSequenceKeypoint.new(1, 0.98)
    })
    lineGradient.Parent = line

    table.insert(dynamicLines, {
        line = line,
        title = title
    })

    local card = Instance.new("Frame")
    card.Name = "Card"
    card.Size = UDim2.new(1, -4, 0, height - 43)
    card.Position = UDim2.new(0, 2, 0, 39)
    card.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
    card.BorderSizePixel = 0
    card.Parent = holder
    corner(card, 13)

    local cardStroke = addStroke(card, 0.70, 1)
    table.insert(dynamicStrokes, cardStroke)

    local inner = Instance.new("Frame")
    inner.Name = "Inner"
    inner.Size = UDim2.new(1, -2, 1, -2)
    inner.Position = UDim2.new(0, 1, 0, 1)
    inner.BackgroundTransparency = 1
    inner.Parent = card
    corner(inner, 12)

    return inner
end

--//======================================================
--// PLAYER STATUS
--//======================================================

local status = section("PLAYER STATUS", 154)

local function findValue(...)
    local names = {...}

    local containers = {
        player:FindFirstChild("leaderstats"),
        player:FindFirstChild("Data"),
        player:FindFirstChild("data")
    }

    for _, container in ipairs(containers) do
        if container then
            for _, name in ipairs(names) do
                local value = container:FindFirstChild(name)
                if value then
                    return value
                end
            end
        end
    end

    for _, name in ipairs(names) do
        local value = player:FindFirstChild(name)
        if value then
            return value
        end
    end

    return nil
end

local function formatNumber(value)
    if not value then
        return "0"
    end

    local raw = value.Value
    local number = tonumber(raw)

    if not number then
        return tostring(raw or 0)
    end

    local text = tostring(math.floor(number))
    local sign = ""

    if text:sub(1, 1) == "-" then
        sign = "-"
        text = text:sub(2)
    end

    while true do
        local replaced, count = text:gsub("^(%d+)(%d%d%d)", "%1,%2")
        text = replaced

        if count == 0 then
            break
        end
    end

    return sign .. text
end

local function createStat(titleText, valueText, x, y)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.5, -10, 0, 38)
    card.Position = UDim2.new(x, 5, 0, y)
    card.BackgroundColor3 = Color3.fromRGB(12, 13, 19)
    card.BorderSizePixel = 0
    card.Parent = status
    corner(card, 9)

    local cardStroke = addStroke(card, 0.88, 1)
    table.insert(dynamicStrokes, cardStroke)

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0, 20)
    indicator.Position = UDim2.new(0, 7, 0.5, -10)
    indicator.BackgroundColor3 = theme()
    indicator.BorderSizePixel = 0
    indicator.Parent = card
    corner(indicator, 4)
    table.insert(dynamicAccents, indicator)

    local title = label(
        card,
        titleText,
        8,
        Color3.fromRGB(115, 120, 135),
        Enum.Font.GothamBold
    )
    title.Size = UDim2.new(0.55, 0, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)

    local value = label(
        card,
        valueText,
        10,
        Color3.fromRGB(240, 242, 248),
        Enum.Font.GothamBold
    )
    value.Size = UDim2.new(0.45, -10, 1, 0)
    value.Position = UDim2.new(0.55, 0, 0, 0)
    value.TextXAlignment = Enum.TextXAlignment.Right

    return title, value
end

local levelValue = findValue("Level", "level")
local beliValue = findValue("Beli", "Money", "money")
local fragmentsValue = findValue("Fragments", "Fragment", "fragments")
local bountyHonorValue = findValue(
    "Bounty/Honor",
    "BountyHonor",
    "Bounty",
    "bounty",
    "Honor",
    "honor"
)

local levelTitle, level = createStat(
    "LEVEL",
    formatNumber(levelValue),
    0,
    7
)

local _, beli = createStat(
    "BELI",
    formatNumber(beliValue),
    0.5,
    7
)

local _, fragments = createStat(
    "FRAGMENTS",
    formatNumber(fragmentsValue),
    0,
    52
)

local reputationTitle, reputation = createStat(
    "BOUNTY",
    "0",
    0.5,
    52
)

local function getTeamKind()
    local team = player.Team

    if not team then
        return "Unknown"
    end

    local name = string.lower(team.Name)

    if string.find(name, "pirate", 1, true)
        or string.find(name, "pira", 1, true) then
        return "Pirates"
    end

    if string.find(name, "marine", 1, true)
        or string.find(name, "mari", 1, true) then
        return "Marines"
    end

    return team.Name
end

local function refreshReputation()
    local kind = getTeamKind()

    bountyHonorValue = findValue(
        "Bounty/Honor",
        "BountyHonor",
        "Bounty",
        "bounty",
        "Honor",
        "honor"
    )

    if kind == "Marines" then
        reputationTitle.Text = "HONOR"
    else
        reputationTitle.Text = "BOUNTY"
    end

    reputation.Text = formatNumber(bountyHonorValue)
end

--//======================================================
--// INFORMATION
--//======================================================

local info = section("INFORMATION", 160)

local avatarHolder = Instance.new("Frame")
avatarHolder.Size = UDim2.new(0, 74, 0, 74)
avatarHolder.Position = UDim2.new(0, 12, 0, 12)
avatarHolder.BackgroundColor3 = Color3.fromRGB(12, 13, 19)
avatarHolder.BorderSizePixel = 0
avatarHolder.Parent = info
corner(avatarHolder, 13)

local avatarStroke = addStroke(avatarHolder, 0.55, 1)
table.insert(dynamicStrokes, avatarStroke)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(1, -6, 1, -6)
avatar.Position = UDim2.new(0, 3, 0, 3)
avatar.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
avatar.BorderSizePixel = 0
avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
avatar.Parent = avatarHolder
corner(avatar, 10)

local avatarAccent = Instance.new("Frame")
avatarAccent.Size = UDim2.new(0, 8, 0, 8)
avatarAccent.Position = UDim2.new(1, -14, 1, -14)
avatarAccent.BackgroundColor3 = theme()
avatarAccent.BorderSizePixel = 0
avatarAccent.Parent = avatarHolder
corner(avatarAccent, 10)
table.insert(dynamicAccents, avatarAccent)

local dn = label(
    info,
    player.DisplayName,
    15,
    Color3.fromRGB(245, 246, 252),
    Enum.Font.GothamBold
)
dn.Position = UDim2.new(0, 98, 0, 11)
dn.Size = UDim2.new(1, -110, 0, 22)

local un = label(
    info,
    "@" .. player.Name,
    10,
    theme(),
    Enum.Font.GothamBold
)
un.Position = UDim2.new(0, 98, 0, 35)
un.Size = UDim2.new(1, -110, 0, 18)
table.insert(dynamicText, un)

local uid = label(
    info,
    "USER ID  •  " .. player.UserId,
    9,
    Color3.fromRGB(135, 140, 155),
    Enum.Font.GothamMedium
)
uid.Position = UDim2.new(0, 98, 0, 56)
uid.Size = UDim2.new(1, -110, 0, 17)

local executorName = "Unknown"

pcall(function()
    if identifyexecutor then
        local a, b = identifyexecutor()
        executorName = tostring(a or b or "Unknown")
    elseif getexecutorname then
        executorName = tostring(getexecutorname())
    end
end)

local ex = label(
    info,
    "EXECUTOR  •  " .. executorName,
    9,
    Color3.fromRGB(135, 140, 155),
    Enum.Font.GothamMedium
)
ex.Position = UDim2.new(0, 98, 0, 77)
ex.Size = UDim2.new(1, -110, 0, 17)

--//======================================================
--// SMALL LIVE STATUS
--//======================================================

local live = Instance.new("Frame")
live.Name = "LiveStatus"
live.Size = UDim2.new(1, -24, 0, 26)
live.Position = UDim2.new(0, 12, 0, 119)
live.BackgroundColor3 = Color3.fromRGB(11, 12, 18)
live.BorderSizePixel = 0
live.Parent = info
corner(live, 8)

local liveDot = Instance.new("Frame")
liveDot.Size = UDim2.new(0, 6, 0, 6)
liveDot.Position = UDim2.new(0, 9, 0.5, -3)
liveDot.BackgroundColor3 = theme()
liveDot.BorderSizePixel = 0
liveDot.Parent = live
corner(liveDot, 10)
table.insert(dynamicAccents, liveDot)

local liveText = label(
    live,
    "ONLINE  •  SESSION ACTIVE",
    8,
    Color3.fromRGB(145, 150, 165),
    Enum.Font.GothamBold
)
liveText.Position = UDim2.new(0, 22, 0, 0)
liveText.Size = UDim2.new(1, -28, 1, 0)

--//======================================================
--// INTRO ANIMATION
--//======================================================

welcome.Position = UDim2.new(0, 0, 0, 7)
welcome.BackgroundTransparency = 1

task.defer(function()
    task.wait(0.05)

    tween(
        welcome,
        {
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 0
        },
        0.45
    ):Play()

    for _, object in ipairs({
        brand,
        welcomeText,
        description,
        gamePill
    }) do
        local oldTransparency = object:IsA("GuiObject") and object.BackgroundTransparency or 0
        if object:IsA("GuiObject") then
            object.BackgroundTransparency = 1
        end

        task.delay(0.08, function()
            if object and object.Parent and object:IsA("GuiObject") then
                tween(
                    object,
                    {BackgroundTransparency = oldTransparency},
                    0.35
                ):Play()
            end
        end)
    end
end)

--//======================================================
--// THEME SYNC
--//======================================================

task.spawn(function()
    while tab.Parent do
        local accentColor = theme()

        accent.BackgroundColor3 = accentColor
        dot.BackgroundColor3 = accentColor
        gameTag.TextColor3 = Color3.fromRGB(222, 224, 232)
        heroGlow.BackgroundColor3 = accentColor
        un.TextColor3 = accentColor
        avatarAccent.BackgroundColor3 = accentColor
        liveDot.BackgroundColor3 = accentColor

        for _, item in ipairs(dynamicLines) do
            if item.line and item.line.Parent then
                item.line.BackgroundColor3 = accentColor
            end

            if item.title and item.title.Parent then
                item.title.TextColor3 = accentColor
            end
        end

        for _, object in ipairs(dynamicAccents) do
            if object and object.Parent then
                object.BackgroundColor3 = accentColor
            end
        end

        for _, object in ipairs(dynamicText) do
            if object and object.Parent then
                object.TextColor3 = accentColor
            end
        end

        for _, s in ipairs(dynamicStrokes) do
            if s and s.Parent then
                s.Color = accentColor
            end
        end

        task.wait(0.08)
    end
end)

--//======================================================
--// LIVE PLAYER DATA
--//======================================================

task.spawn(function()
    while tab.Parent do
        levelValue = findValue("Level", "level")
        beliValue = findValue("Beli", "Money", "money")
        fragmentsValue = findValue("Fragments", "Fragment", "fragments")
        bountyHonorValue = findValue(
            "Bounty/Honor",
            "BountyHonor",
            "Bounty",
            "bounty",
            "Honor",
            "honor"
        )

        level.Text = formatNumber(levelValue)
        beli.Text = formatNumber(beliValue)
        fragments.Text = formatNumber(fragmentsValue)

        refreshReputation()

        task.wait(0.35)
    end
end)

--//======================================================
--// TEAM CHANGE REFRESH
--//======================================================

player:GetPropertyChangedSignal("Team"):Connect(function()
    if tab.Parent then
        refreshReputation()
    end
end)

--//======================================================
--// HOVER FEEDBACK
--//======================================================

local function hoverCard(card)
    local original = card.BackgroundColor3

    card.MouseEnter:Connect(function()
        if not card.Parent then return end

        tween(
            card,
            {
                BackgroundColor3 = Color3.fromRGB(16, 17, 24)
            },
            0.18
        ):Play()
    end)

    card.MouseLeave:Connect(function()
        if not card.Parent then return end

        tween(
            card,
            {
                BackgroundColor3 = original
            },
            0.18
        ):Play()
    end)
end

for _, object in ipairs(status:GetChildren()) do
    if object:IsA("Frame") then
        hoverCard(object)
    end
end