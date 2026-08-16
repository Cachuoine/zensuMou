local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")

local context = ...
local player = (context and context.Player) or Players.LocalPlayer
if not player then return end

local gui = (context and context.PlayerGui) or player:WaitForChild("PlayerGui", 10)
if not gui then return end

local tab = (context and context.Tab)
if not tab then
    local fishHub = gui:FindFirstChild("FishHub")
    if not fishHub then return end
    local mainWindow = fishHub:FindFirstChild("MainWindow")
    local contentContainer = mainWindow and mainWindow:FindFirstChild("ContentContainer")
    tab = contentContainer and contentContainer:FindFirstChild("HomeTab", true)
end

if not tab then return end

for _, child in ipairs(tab:GetChildren()) do
    child:Destroy()
end

local function getTheme()
    local main = (context and context.MainWindow) or fishHub:FindFirstChild("MainWindow")
    local stroke = main and main:FindFirstChildOfClass("UIStroke")
    return stroke and stroke.Color or Color3.fromRGB(0, 229, 255)
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
end

local function section(parent, title, height)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -8, 0, height)
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.Parent = parent

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 1)
    top.Position = UDim2.new(0, 0, 0, 15)
    top.BackgroundColor3 = getTheme()
    top.BorderSizePixel = 0
    top.Parent = holder

    local topGradient = Instance.new("UIGradient")
    topGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.2, 0.55),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.8, 0.55),
        NumberSequenceKeypoint.new(1, 0.9)
    })
    topGradient.Parent = top

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 180, 0, 30)
    label.Position = UDim2.new(0.5, -90, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = getTheme()
    label.Text = title
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Parent = holder

    local bottom = top:Clone()
    bottom.Position = UDim2.new(0, 0, 1, -1)
    bottom.Parent = holder

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -20, 1, -46)
    card.Position = UDim2.new(0, 10, 0, 30)
    card.BackgroundColor3 = Color3.fromRGB(8, 9, 13)
    card.BackgroundTransparency = 0.08
    card.BorderSizePixel = 0
    card.Parent = holder
    corner(card, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color = getTheme()
    stroke.Transparency = 0.65
    stroke.Thickness = 1
    stroke.Parent = card

    return holder, card
end

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 12)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = tab

local welcome = Instance.new("Frame")
welcome.Size = UDim2.new(1, -8, 0, 78)
welcome.BackgroundColor3 = Color3.fromRGB(8, 9, 13)
welcome.BackgroundTransparency = 0.08
welcome.BorderSizePixel = 0
welcome.Parent = tab
corner(welcome, 10)

local welcomeStroke = Instance.new("UIStroke")
welcomeStroke.Color = getTheme()
welcomeStroke.Transparency = 0.55
welcomeStroke.Parent = welcome

local gameName = "Roblox Game"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then
        gameName = info.Name
    end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 0, 28)
title.Position = UDim2.new(0, 12, 0, 9)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextColor3 = getTheme()
title.Text = "WELCOME TO FISHHUB"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = welcome

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -24, 0, 28)
subtitle.Position = UDim2.new(0, 12, 0, 39)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 11
subtitle.TextColor3 = Color3.fromRGB(180, 185, 200)
subtitle.Text = "READY TO EXPERIENCE  •  " .. gameName
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = welcome

local statusHolder, statusCard = section(tab, "PLAYER STATUS", 125)
statusHolder.LayoutOrder = 2

local infoHolder, infoCard = section(tab, "INFORMATION", 150)
infoHolder.LayoutOrder = 3

local function findStat(...)
    local names = {...}
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return nil end
    for _, name in ipairs(names) do
        local value = leaderstats:FindFirstChild(name)
        if value then
            return value
        end
    end
    return nil
end

local function valueText(...)
    local obj = findStat(...)
    return obj and tostring(obj.Value) or "0"
end

local function formatNumber(value)
    local n = tonumber(value)
    if not n then return tostring(value) end
    local s = tostring(math.floor(n))
    local sign = ""
    if s:sub(1,1) == "-" then
        sign = "-"
        s = s:sub(2)
    end
    while true do
        local replaced, count = s:gsub("^(%d+)(%d%d%d)", "%1,%2")
        s = replaced
        if count == 0 then break end
    end
    return sign .. s
end

local function addStatusRow(parent, x, y, labelText, valueTextValue)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.5, -8, 0, 30)
    row.Position = UDim2.new(x, 4, 0, y)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.48, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 10
    label.TextColor3 = Color3.fromRGB(140, 145, 160)
    label.Text = labelText
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0.52, 0, 1, 0)
    value.Position = UDim2.new(0.48, 0, 0, 0)
    value.BackgroundTransparency = 1
    value.Font = Enum.Font.GothamBold
    value.TextSize = 11
    value.TextColor3 = Color3.fromRGB(240, 242, 248)
    value.Text = valueTextValue
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.Parent = row

    return value
end

local levelLabel = addStatusRow(statusCard, 0, 8, "LEVEL", formatNumber(valueText("Level", "level")))
local beliLabel = addStatusRow(statusCard, 0.5, 8, "BELI", formatNumber(valueText("Beli", "Money", "money")))
local fragmentLabel = addStatusRow(statusCard, 0, 42, "FRAGMENTS", formatNumber(valueText("Fragments", "Fragment", "fragments")))
local factionTitleLabel = addStatusRow(statusCard, 0.5, 42, "BOUNTY", "0")

local function findDescendantValue(root, names)
    if not root then return nil end
    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") or obj:IsA("StringValue") then
            local n = string.lower(obj.Name)
            for _, wanted in ipairs(names) do
                if n == string.lower(wanted) then
                    return obj
                end
            end
        end
    end
end

local function findReputation(kind)
    local wanted = kind == "Marines" and {"Honor", "honor"} or {"Bounty", "bounty"}
    local containers = {
        player:FindFirstChild("leaderstats"),
        player:FindFirstChild("Data"),
        player:FindFirstChild("data"),
        player
    }
    for _, container in ipairs(containers) do
        local value = findDescendantValue(container, wanted)
        if value then return value end
    end
end

local function getFaction()
    local team = player.Team
    if not team then return "Unknown" end
    local name = string.lower(team.Name)
    if string.find(name, "pirate", 1, true) or string.find(name, "pira", 1, true) then
        return "Pirates"
    end
    if string.find(name, "marine", 1, true) or string.find(name, "mari", 1, true) then
        return "Marines"
    end
    return "Unknown"
end

local function refreshReputation()
    local faction = getFaction()
    local stat = findReputation(faction)
    if faction == "Marines" then
        factionTitleLabel.Parent:FindFirstChildWhichIsA("TextLabel").Text = "HONOR"
    else
        factionTitleLabel.Parent:FindFirstChildWhichIsA("TextLabel").Text = "BOUNTY"
    end
    factionTitleLabel.Text = stat and formatNumber(stat.Value) or "0"
end

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 58, 0, 58)
avatar.Position = UDim2.new(0, 12, 0, 11)
avatar.BackgroundColor3 = Color3.fromRGB(18, 20, 27)
avatar.BorderSizePixel = 0
avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
avatar.Parent = infoCard
corner(avatar, 10)

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, -88, 0, 22)
nameLabel.Position = UDim2.new(0, 72, 0, 10)
nameLabel.BackgroundTransparency = 1
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 13
nameLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
nameLabel.Text = player.DisplayName
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = infoCard

local usernameLabel = nameLabel:Clone()
usernameLabel.Position = UDim2.new(0, 72, 0, 32)
usernameLabel.TextSize = 10
usernameLabel.Font = Enum.Font.GothamMedium
usernameLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
usernameLabel.Text = "@" .. player.Name
usernameLabel.Parent = infoCard

local useridLabel = nameLabel:Clone()
useridLabel.Position = UDim2.new(0, 72, 0, 54)
useridLabel.TextSize = 10
useridLabel.TextColor3 = Color3.fromRGB(170, 175, 190)
useridLabel.Text = "UserId: " .. tostring(player.UserId)
useridLabel.Parent = infoCard

local executor = "Unknown"
pcall(function()
    if identifyexecutor then
        local a, b = identifyexecutor()
        executor = tostring(a or b or "Unknown")
    elseif getexecutorname then
        executor = tostring(getexecutorname())
    end
end)

local executorLabel = useridLabel:Clone()
executorLabel.Position = UDim2.new(0, 72, 0, 76)
executorLabel.Text = "Executor: " .. executor
executorLabel.Parent = infoCard

local function refresh()
    levelLabel.Text = formatNumber(valueText("Level", "level"))
    beliLabel.Text = formatNumber(valueText("Beli", "Money", "money"))
    fragmentLabel.Text = formatNumber(valueText("Fragments", "Fragment", "fragments"))
    refreshReputation()
end

task.spawn(function()
    while tab.Parent do
        refresh()
        task.wait(1)
    end
end)
