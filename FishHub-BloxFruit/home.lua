-- FishHub • Home.lua
-- Clean Home Tab
-- Circular background bubbles removed

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

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
    tab = content and content:FindFirstChild("HomeTab", true)
    main = main or mainWindow
end

if not tab then return end

for _, child in ipairs(tab:GetChildren()) do child:Destroy() end
tab.ClipsDescendants = true

local function theme()
    local s = main and main:FindFirstChildOfClass("UIStroke")
    return s and s.Color or Color3.fromRGB(104, 82, 255)
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function addStroke(parent, transparency)
    local s = Instance.new("UIStroke")
    s.Color = theme()
    s.Thickness = 1
    s.Transparency = transparency or .55
    s.Parent = parent
    return s
end

local function label(parent, text, size, color, font)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Font = font or Enum.Font.GothamMedium
    x.TextSize = size
    x.TextColor3 = color
    x.Text = text
    x.Parent = parent
    return x
end

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "HomeScroll"
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 0
scroll.ScrollBarImageTransparency = 1
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new()
scroll.Parent = tab

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 5)
padding.PaddingRight = UDim.new(0, 5)
padding.PaddingTop = UDim.new(0, 4)
padding.PaddingBottom = UDim.new(0, 14)
padding.Parent = scroll

local root = Instance.new("Frame")
root.Name = "HomeContent"
root.Size = UDim2.new(1, -10, 0, 0)
root.AutomaticSize = Enum.AutomaticSize.Y
root.BackgroundTransparency = 1
root.Parent = scroll

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 15)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = root

local welcome = Instance.new("Frame")
welcome.Name = "Welcome"
welcome.Size = UDim2.new(1, 0, 0, 104)
welcome.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
welcome.BorderSizePixel = 0
welcome.Parent = root
corner(welcome, 12)
addStroke(welcome, .42)

local accent = Instance.new("Frame")
accent.Size = UDim2.new(0, 4, 1, -28)
accent.Position = UDim2.new(0, 13, 0, 14)
accent.BackgroundColor3 = theme()
accent.BorderSizePixel = 0
accent.Parent = welcome
corner(accent, 3)

local title = label(welcome, "FISHHUB", 20, Color3.fromRGB(245, 246, 252), Enum.Font.GothamBlack)
title.Position = UDim2.new(0, 30, 0, 14)
title.Size = UDim2.new(1, -45, 0, 25)

local subtitle = label(welcome, "Ready to experience your control panel", 10, Color3.fromRGB(145, 150, 165))
subtitle.Position = UDim2.new(0, 31, 0, 42)
subtitle.Size = UDim2.new(1, -45, 0, 18)

local gameName = "Roblox"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then gameName = info.Name end
end)

local gameTag = label(welcome, "●  " .. gameName, 9, theme(), Enum.Font.GothamBold)
gameTag.Position = UDim2.new(0, 31, 0, 70)
gameTag.Size = UDim2.new(1, -45, 0, 18)

local function section(titleText, height)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, height)
    holder.BackgroundTransparency = 1
    holder.Parent = root

    local t = label(holder, titleText, 10, theme(), Enum.Font.GothamBold)
    t.Size = UDim2.new(0, 170, 0, 18)
    t.Position = UDim2.new(.5, -85, 0, 0)
    t.TextXAlignment = Enum.TextXAlignment.Center
    t.ZIndex = 3

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0, 24)
    line.BackgroundColor3 = theme()
    line.BorderSizePixel = 0
    line.Parent = holder

    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, .96),
        NumberSequenceKeypoint.new(.18, .60),
        NumberSequenceKeypoint.new(.50, 0),
        NumberSequenceKeypoint.new(.82, .60),
        NumberSequenceKeypoint.new(1, .96)
    })
    gradient.Parent = line

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, height - 43)
    card.Position = UDim2.new(0, 2, 0, 39)
    card.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
    card.BorderSizePixel = 0
    card.Parent = holder
    corner(card, 11)
    addStroke(card, .65)
    return card
end

local status = section("PLAYER STATUS", 136)

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
                if value then return value end
            end
        end
    end
    for _, name in ipairs(names) do
        local value = player:FindFirstChild(name)
        if value then return value end
    end
end

local function formatNumber(value)
    if not value then return "0" end
    local number = tonumber(value.Value)
    if not number then return tostring(value.Value or 0) end
    local text = tostring(math.floor(number))
    local sign = ""
    if text:sub(1, 1) == "-" then sign, text = "-", text:sub(2) end
    while true do
        local replaced, count = text:gsub("^(%d+)(%d%d%d)", "%1,%2")
        text = replaced
        if count == 0 then break end
    end
    return sign .. text
end

local function createStat(titleText, valueText, x, y)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(.5, -9, 0, 34)
    card.Position = UDim2.new(x, 4, 0, y)
    card.BackgroundColor3 = Color3.fromRGB(12, 13, 19)
    card.BorderSizePixel = 0
    card.Parent = status
    corner(card, 7)

    local t = label(card, titleText, 8, Color3.fromRGB(115, 120, 135), Enum.Font.GothamBold)
    t.Size = UDim2.new(.58, 0, 1, 0)
    t.Position = UDim2.new(0, 8, 0, 0)

    local v = label(card, valueText, 9, Color3.fromRGB(240, 242, 248), Enum.Font.GothamBold)
    v.Size = UDim2.new(.42, -8, 1, 0)
    v.Position = UDim2.new(.58, 0, 0, 0)
    v.TextXAlignment = Enum.TextXAlignment.Right
    return t, v
end

local levelValue = findValue("Level", "level")
local beliValue = findValue("Beli", "Money", "money")
local fragmentsValue = findValue("Fragments", "Fragment", "fragments")

local _, level = createStat("LEVEL", formatNumber(levelValue), 0, 7)
local _, beli = createStat("BELI", formatNumber(beliValue), .5, 7)
local _, fragments = createStat("FRAGMENTS", formatNumber(fragmentsValue), 0, 48)
local reputationTitle, reputation = createStat("BOUNTY", "0", .5, 48)

local function getTeamKind()
    local team = player.Team
    if not team then return "Unknown" end
    local name = string.lower(team.Name)
    if string.find(name, "pirate", 1, true) or string.find(name, "pira", 1, true) then return "Pirates" end
    if string.find(name, "marine", 1, true) or string.find(name, "mari", 1, true) then return "Marines" end
    return team.Name
end

local function refreshReputation()
    local kind = getTeamKind()
    if kind == "Pirates" then
        reputationTitle.Text = "BOUNTY"
        reputation.Text = formatNumber(findValue("Bounty", "bounty"))
    elseif kind == "Marines" then
        reputationTitle.Text = "HONOR"
        reputation.Text = formatNumber(findValue("Honor", "honor"))
    else
        reputationTitle.Text = "BOUNTY"
        reputation.Text = formatNumber(findValue("Bounty", "bounty"))
    end
end

local info = section("INFORMATION", 142)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 64, 0, 64)
avatar.Position = UDim2.new(0, 13, 0, 12)
avatar.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
avatar.BorderSizePixel = 0
avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
avatar.Parent = info
corner(avatar, 10)

local displayName = label(info, player.DisplayName, 14, Color3.fromRGB(245, 246, 252), Enum.Font.GothamBold)
displayName.Position = UDim2.new(0, 91, 0, 11)
displayName.Size = UDim2.new(1, -105, 0, 21)

local username = label(info, "@" .. player.Name, 10, theme(), Enum.Font.GothamBold)
username.Position = UDim2.new(0, 91, 0, 34)
username.Size = UDim2.new(1, -105, 0, 18)

local userId = label(info, "USER ID  •  " .. player.UserId, 9, Color3.fromRGB(135, 140, 155), Enum.Font.GothamMedium)
userId.Position = UDim2.new(0, 91, 0, 54)
userId.Size = UDim2.new(1, -105, 0, 17)

local executorName = "Unknown"
pcall(function()
    if identifyexecutor then
        local a, b = identifyexecutor()
        executorName = tostring(a or b or "Unknown")
    elseif getexecutorname then
        executorName = tostring(getexecutorname())
    end
end)

local executor = label(info, "EXECUTOR  •  " .. executorName, 9, Color3.fromRGB(135, 140, 155), Enum.Font.GothamMedium)
executor.Position = UDim2.new(0, 91, 0, 74)
executor.Size = UDim2.new(1, -105, 0, 17)

local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, -26, 0, 1)
separator.Position = UDim2.new(0, 13, 0, 98)
separator.BackgroundColor3 = Color3.fromRGB(30, 31, 40)
separator.BorderSizePixel = 0
separator.Parent = info

local hint = label(info, "CURRENT SESSION", 8, Color3.fromRGB(95, 100, 115), Enum.Font.GothamBold)
hint.Position = UDim2.new(0, 13, 0, 109)
hint.Size = UDim2.new(1, -26, 0, 17)

task.spawn(function()
    while tab.Parent do
        levelValue = findValue("Level", "level")
        beliValue = findValue("Beli", "Money", "money")
        fragmentsValue = findValue("Fragments", "Fragment", "fragments")
        level.Text = formatNumber(levelValue)
        beli.Text = formatNumber(beliValue)
        fragments.Text = formatNumber(fragmentsValue)
        refreshReputation()
        task.wait(.5)
    end
end)

task.spawn(function()
    while tab.Parent do
        local color = theme()
        accent.BackgroundColor3 = color
        gameTag.TextColor3 = color
        username.TextColor3 = color
        task.wait(.12)
    end
end)
