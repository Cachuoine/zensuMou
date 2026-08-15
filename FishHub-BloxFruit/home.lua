local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

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

local function theme()
    local stroke = main and main:FindFirstChildOfClass("UIStroke")
    return stroke and stroke.Color or Color3.fromRGB(105, 82, 255)
end

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

local function addStroke(parent, transparency)
    local s = Instance.new("UIStroke")
    s.Color = theme()
    s.Thickness = 1
    s.Transparency = transparency or 0.55
    s.Parent = parent
    return s
end

local function addText(parent, text, size, color, font)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Font = font or Enum.Font.GothamMedium
    label.TextSize = size
    label.TextColor3 = color
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local root = Instance.new("Frame")
root.Name = "HomeContent"
root.Size = UDim2.new(1, -10, 0, 500)
root.BackgroundTransparency = 1
root.Parent = tab

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 14)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = root

local welcome = Instance.new("Frame")
welcome.LayoutOrder = 1
welcome.Size = UDim2.new(1, -4, 0, 86)
welcome.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
welcome.BorderSizePixel = 0
welcome.Parent = root
addCorner(welcome, 12)
addStroke(welcome, 0.35)

local glow = Instance.new("Frame")
glow.Size = UDim2.new(0, 4, 1, -22)
glow.Position = UDim2.new(0, 12, 0, 11)
glow.BackgroundColor3 = theme()
glow.BorderSizePixel = 0
glow.Parent = welcome
addCorner(glow, 3)

local welcomeTitle = addText(welcome, "READY TO EXPERIENCE...", 18, Color3.fromRGB(245, 246, 252), Enum.Font.GothamBold)
welcomeTitle.Position = UDim2.new(0, 30, 0, 17)
welcomeTitle.Size = UDim2.new(1, -44, 0, 25)

local gameName = "Roblox"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then
        gameName = info.Name
    end
end)

local gamePill = Instance.new("Frame")
gamePill.Size = UDim2.new(0, 220, 0, 25)
gamePill.Position = UDim2.new(0, 30, 0, 49)
gamePill.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
gamePill.BorderSizePixel = 0
gamePill.Parent = welcome
addCorner(gamePill, 7)
addStroke(gamePill, 0.72)

local gameText = addText(gamePill, "GAME  •  " .. gameName, 9, theme(), Enum.Font.GothamBold)
gameText.Size = UDim2.new(1, -14, 1, 0)
gameText.Position = UDim2.new(0, 7, 0, 0)

local function createSection(titleText, height, order)
    local holder = Instance.new("Frame")
    holder.LayoutOrder = order
    holder.Size = UDim2.new(1, -4, 0, height)
    holder.BackgroundTransparency = 1
    holder.Parent = root

    local title = addText(holder, titleText, 11, theme(), Enum.Font.GothamBold)
    title.Size = UDim2.new(0, 180, 0, 20)
    title.Position = UDim2.new(0.5, -90, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Center

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0, 25)
    line.BackgroundColor3 = theme()
    line.BorderSizePixel = 0
    line.Parent = holder

    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.92),
        NumberSequenceKeypoint.new(0.18, 0.58),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.82, 0.58),
        NumberSequenceKeypoint.new(1, 0.92)
    })
    gradient.Parent = line

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, height - 42)
    card.Position = UDim2.new(0, 4, 0, 39)
    card.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
    card.BorderSizePixel = 0
    card.Parent = holder
    addCorner(card, 10)
    addStroke(card, 0.62)

    return holder, card
end

local _, status = createSection("PLAYER STATUS", 136, 2)

local function stat(parent, title, value, x, y)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.5, -10, 0, 36)
    row.Position = UDim2.new(x, 5, 0, y)
    row.BackgroundColor3 = Color3.fromRGB(12, 13, 19)
    row.BorderSizePixel = 0
    row.Parent = parent
    addCorner(row, 7)

    local a = addText(row, title, 8, Color3.fromRGB(125, 130, 145), Enum.Font.GothamBold)
    a.Size = UDim2.new(0.5, -8, 1, 0)
    a.Position = UDim2.new(0, 8, 0, 0)

    local b = addText(row, value, 10, Color3.fromRGB(240, 242, 248), Enum.Font.GothamBold)
    b.Size = UDim2.new(0.5, -8, 1, 0)
    b.Position = UDim2.new(0.5, 0, 0, 0)
    b.TextXAlignment = Enum.TextXAlignment.Right

    return b
end

local function findStat(...)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return nil end
    for _, name in ipairs({...}) do
        local value = leaderstats:FindFirstChild(name)
        if value then return value end
    end
end

local function numberText(value)
    local n = tonumber(value)
    if not n then return tostring(value or 0) end
    local s = tostring(math.floor(n))
    local sign = ""
    if s:sub(1, 1) == "-" then
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

local levelObject = findStat("Level", "level")
local beliObject = findStat("Beli", "Money", "money")
local fragmentObject = findStat("Fragments", "Fragment", "fragments")

local level = stat(status, "LEVEL", numberText(levelObject and levelObject.Value), 0, 7)
local beli = stat(status, "BELI", numberText(beliObject and beliObject.Value), 0.5, 7)
local fragments = stat(status, "FRAGMENTS", numberText(fragmentObject and fragmentObject.Value), 0, 48)
local reputationTitle
local reputation

local reputationRow = Instance.new("Frame")
reputationRow.Size = UDim2.new(0.5, -10, 0, 36)
reputationRow.Position = UDim2.new(0.5, 5, 0, 48)
reputationRow.BackgroundColor3 = Color3.fromRGB(12, 13, 19)
reputationRow.BorderSizePixel = 0
reputationRow.Parent = status
addCorner(reputationRow, 7)

reputationTitle = addText(reputationRow, "BOUNTY", 8, Color3.fromRGB(125, 130, 145), Enum.Font.GothamBold)
reputationTitle.Size = UDim2.new(0.5, -8, 1, 0)
reputationTitle.Position = UDim2.new(0, 8, 0, 0)

reputation = addText(reputationRow, "0", 10, Color3.fromRGB(240, 242, 248), Enum.Font.GothamBold)
reputation.Size = UDim2.new(0.5, -8, 1, 0)
reputation.Position = UDim2.new(0.5, 0, 0, 0)
reputation.TextXAlignment = Enum.TextXAlignment.Right

local function currentTeamKind()
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
    if currentTeamKind() == "Marines" then
        reputationTitle.Text = "HONOR"
        local honorObject = findStat("Honor", "honor")
        reputation.Text = numberText(honorObject and honorObject.Value)
    else
        reputationTitle.Text = "BOUNTY"
        local bountyObject = findStat("Bounty", "bounty")
        reputation.Text = numberText(bountyObject and bountyObject.Value)
    end
end

local _, information = createSection("INFORMATION", 165, 3)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 66, 0, 66)
avatar.Position = UDim2.new(0, 14, 0, 13)
avatar.BackgroundColor3 = Color3.fromRGB(15, 16, 23)
avatar.BorderSizePixel = 0
avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
avatar.Parent = information
addCorner(avatar, 10)

local display = addText(information, player.DisplayName, 14, Color3.fromRGB(245, 246, 252), Enum.Font.GothamBold)
display.Position = UDim2.new(0, 86, 0, 11)
display.Size = UDim2.new(1, -100, 0, 22)

local username = addText(information, "@" .. player.Name, 10, theme(), Enum.Font.GothamBold)
username.Position = UDim2.new(0, 86, 0, 35)
username.Size = UDim2.new(1, -100, 0, 18)

local userid = addText(information, "USER ID  •  " .. tostring(player.UserId), 9, Color3.fromRGB(140, 145, 160), Enum.Font.GothamMedium)
userid.Position = UDim2.new(0, 86, 0, 55)
userid.Size = UDim2.new(1, -100, 0, 18)

local executorName = "Unknown"
pcall(function()
    if identifyexecutor then
        local a, b = identifyexecutor()
        executorName = tostring(a or b or "Unknown")
    elseif getexecutorname then
        executorName = tostring(getexecutorname())
    end
end)

local executor = addText(information, "EXECUTOR  •  " .. executorName, 9, Color3.fromRGB(140, 145, 160), Enum.Font.GothamMedium)
executor.Position = UDim2.new(0, 86, 0, 75)
executor.Size = UDim2.new(1, -100, 0, 18)

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -28, 0, 1)
divider.Position = UDim2.new(0, 14, 0, 96)
divider.BackgroundColor3 = Color3.fromRGB(30, 31, 40)
divider.BorderSizePixel = 0
divider.Parent = information

local infoHint = addText(information, "SESSION INFORMATION", 8, Color3.fromRGB(100, 105, 120), Enum.Font.GothamBold)
infoHint.Position = UDim2.new(0, 14, 0, 106)
infoHint.Size = UDim2.new(1, -28, 0, 16)

refreshReputation()

task.spawn(function()
    while tab.Parent do
        local levelObj = findStat("Level", "level")
        local beliObj = findStat("Beli", "Money", "money")
        local fragObj = findStat("Fragments", "Fragment", "fragments")
        if levelObj then level.Text = numberText(levelObj.Value) end
        if beliObj then beli.Text = numberText(beliObj.Value) end
        if fragObj then fragments.Text = numberText(fragObj.Value) end
        refreshReputation()
        task.wait(0.5)
    end
end)
