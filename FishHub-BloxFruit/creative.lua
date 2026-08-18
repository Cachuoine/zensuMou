-- FishHub Creative tab
-- Rebuilt from scratch: Roblox Player / Discord / Facebook

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local context = ...
local player = (context and context.Player) or Players.LocalPlayer
if not player then
    return
end

local playerGui = (context and context.PlayerGui) or player:WaitForChild("PlayerGui", 10)
local tab = context and context.Tab
local main = context and (context.MainWindow or context.Main)
local ShowNotification = context and context.ShowNotification
local Config = context and context.Config

if not tab then
    local fishHub = playerGui and playerGui:FindFirstChild("FishHub")
    local mainWindow = fishHub and fishHub:FindFirstChild("MainWindow")
    main = main or mainWindow
    local content = mainWindow and mainWindow:FindFirstChild("ContentContainer")
    tab = content and content:FindFirstChild("CreativeTab", true)
end

if not tab then
    return
end

for _, child in ipairs(tab:GetChildren()) do
    child:Destroy()
end

tab.ClipsDescendants = true
tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

tab.ScrollBarThickness = 0
tab.ScrollBarImageTransparency = 1

tab.ScrollingDirection = Enum.ScrollingDirection.Y

local DISCORD_URL = "https://discord.gg/zFN6Nd99fC"
local FACEBOOK_URL = "https://www.facebook.com/dao.huy.lam.09/"

local function accent()
    if Config and typeof(Config.ThemeColor) == "Color3" then
        return Config.ThemeColor
    end
    if main then
        local stroke = main:FindFirstChildOfClass("UIStroke")
        if stroke then
            return stroke.Color
        end
    end
    return Color3.fromRGB(0, 229, 255)
end

local function notify(message)
    if type(ShowNotification) == "function" then
        pcall(ShowNotification, message)
    end
end

local function corner(instance, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = instance
end

local function stroke(instance, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or accent()
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = instance
    return s
end

local function label(parent, text, size, color, font)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Text = text
    x.Font = font or Enum.Font.GothamMedium
    x.TextSize = size or 11
    x.TextColor3 = color or Color3.fromRGB(235, 238, 245)
    x.TextXAlignment = Enum.TextXAlignment.Center
    x.TextYAlignment = Enum.TextYAlignment.Center
    x.Parent = parent
    return x
end

local root = Instance.new("Frame")
root.Name = "CreativeRoot"
root.Parent = tab
root.Size = UDim2.new(1, -20, 0, 0)
root.Position = UDim2.new(0, 10, 0, 6)
root.AutomaticSize = Enum.AutomaticSize.Y
root.BackgroundTransparency = 1

local list = Instance.new("UIListLayout")
list.Parent = root
list.Padding = UDim.new(0, 18)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.SortOrder = Enum.SortOrder.LayoutOrder

local function makeSection(titleText, order)
    local holder = Instance.new("Frame")
    holder.Name = titleText:gsub("%s+", "") .. "Section"
    holder.Parent = root
    holder.Size = UDim2.new(1, 0, 0, 118)
    holder.BackgroundTransparency = 1
    holder.LayoutOrder = order

    local title = label(holder, titleText, 10, accent(), Enum.Font.GothamBold)
    title.Size = UDim2.new(0, 260, 0, 18)
    title.Position = UDim2.new(0.5, -130, 0, 0)
    title.ZIndex = 3

    local line = Instance.new("Frame")
    line.Name = "CenterFadeLine"
    line.Parent = holder
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0, 25)
    line.BackgroundColor3 = accent()
    line.BorderSizePixel = 0
    line.ZIndex = 1

    local gradient = Instance.new("UIGradient")
    gradient.Parent = line
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.12, 0.94),
        NumberSequenceKeypoint.new(0.25, 0.68),
        NumberSequenceKeypoint.new(0.38, 0.25),
        NumberSequenceKeypoint.new(0.50, 0),
        NumberSequenceKeypoint.new(0.62, 0.25),
        NumberSequenceKeypoint.new(0.75, 0.68),
        NumberSequenceKeypoint.new(0.88, 0.94),
        NumberSequenceKeypoint.new(1, 1),
    })

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Parent = holder
    content.Size = UDim2.new(1, -8, 0, 78)
    content.Position = UDim2.new(0, 4, 0, 39)
    content.BackgroundColor3 = Color3.fromRGB(9, 11, 17)
    content.BackgroundTransparency = 0.14
    content.BorderSizePixel = 0
    content.ZIndex = 2
    corner(content, 11)
    local contentStroke = stroke(content, accent(), 1, 0.62)

    return holder, content, title, line, contentStroke
end

-- 1. ROBLOX PLAYER
local _, robloxCard = makeSection("ROBLOX PLAYER", 1)

local avatar = Instance.new("ImageLabel")
avatar.Parent = robloxCard
avatar.Size = UDim2.fromOffset(52, 52)
avatar.Position = UDim2.new(0, 14, 0.5, 0)
avatar.AnchorPoint = Vector2.new(0, 0.5)
avatar.BackgroundColor3 = Color3.fromRGB(18, 20, 29)
avatar.BorderSizePixel = 0
avatar.ScaleType = Enum.ScaleType.Crop
avatar.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", player.UserId)
corner(avatar, 10)

local displayName = label(robloxCard, player.DisplayName, 13, Color3.fromRGB(245, 247, 252), Enum.Font.GothamBold)
displayName.Size = UDim2.new(0.45, 0, 0, 22)
displayName.Position = UDim2.new(0, 78, 0, 12)
displayName.TextXAlignment = Enum.TextXAlignment.Left

displayName.TextTruncate = Enum.TextTruncate.AtEnd

local username = label(robloxCard, "@" .. player.Name, 10, accent(), Enum.Font.GothamBold)
username.Size = UDim2.new(0.45, 0, 0, 18)
username.Position = UDim2.new(0, 78, 0, 37)
username.TextXAlignment = Enum.TextXAlignment.Left

local robloxHint = label(robloxCard, "PLAYER PROFILE", 8, Color3.fromRGB(112, 118, 132), Enum.Font.GothamMedium)
robloxHint.Size = UDim2.new(0, 120, 0, 16)
robloxHint.Position = UDim2.new(1, -134, 0, 9)
robloxHint.TextXAlignment = Enum.TextXAlignment.Right

-- 2. DISCORD
local _, discordCard = makeSection("SERVER DISCORD", 2)

discordCard.BackgroundColor3 = Color3.fromRGB(9, 11, 18)

local discordIcon = label(discordCard, "◈", 20, Color3.fromRGB(210, 214, 224), Enum.Font.GothamBold)
discordIcon.Size = UDim2.fromOffset(42, 42)
discordIcon.Position = UDim2.new(0, 14, 0.5, -21)

local discordName = label(discordCard, "FishHub Community", 12, Color3.fromRGB(240, 243, 250), Enum.Font.GothamBold)
discordName.Size = UDim2.new(0, 180, 0, 20)
discordName.Position = UDim2.new(0, 62, 0, 9)
discordName.TextXAlignment = Enum.TextXAlignment.Left

local discordSub = label(discordCard, "SERVER • COMMUNITY", 8, Color3.fromRGB(110, 116, 130), Enum.Font.GothamMedium)
discordSub.Size = UDim2.new(0, 180, 0, 16)
discordSub.Position = UDim2.new(0, 62, 0, 31)
discordSub.TextXAlignment = Enum.TextXAlignment.Left

local discordButton = Instance.new("TextButton")
discordButton.Parent = discordCard
discordButton.Size = UDim2.new(0, 112, 0, 30)
discordButton.Position = UDim2.new(1, -126, 0.5, -15)
discordButton.BackgroundColor3 = accent()
discordButton.BorderSizePixel = 0
discordButton.AutoButtonColor = false
discordButton.Text = "JOIN SERVER"
discordButton.Font = Enum.Font.GothamBold
discordButton.TextSize = 10
discordButton.TextColor3 = Color3.fromRGB(24, 27, 34)
discordButton.ZIndex = 5
corner(discordButton, 7)
local discordStroke = stroke(discordButton, accent(), 1, 0.1)

discordButton.MouseEnter:Connect(function()
    discordButton.BackgroundColor3 = accent():Lerp(Color3.new(1, 1, 1), 0.10)
end)
discordButton.MouseLeave:Connect(function()
    discordButton.BackgroundColor3 = accent()
end)
discordButton.Activated:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(DISCORD_URL)
        end
    end)
    notify("Discord link copied successfully!")
end)

-- 3. FACEBOOK
local _, facebookCard = makeSection("FACEBOOK PLAYER", 3)

local facebookIcon = label(facebookCard, "f", 22, Color3.fromRGB(210, 214, 224), Enum.Font.GothamBold)
facebookIcon.Size = UDim2.fromOffset(42, 42)
facebookIcon.Position = UDim2.new(0, 14, 0.5, -21)

local facebookName = label(facebookCard, "Dao Huy Lam", 12, Color3.fromRGB(240, 243, 250), Enum.Font.GothamBold)
facebookName.Size = UDim2.new(0, 170, 0, 20)
facebookName.Position = UDim2.new(0, 62, 0, 9)
facebookName.TextXAlignment = Enum.TextXAlignment.Left

local facebookSub = label(facebookCard, "SOCIAL PROFILE", 8, Color3.fromRGB(110, 116, 130), Enum.Font.GothamMedium)
facebookSub.Size = UDim2.new(0, 170, 0, 16)
facebookSub.Position = UDim2.new(0, 62, 0, 31)
facebookSub.TextXAlignment = Enum.TextXAlignment.Left

local facebookButton = Instance.new("TextButton")
facebookButton.Parent = facebookCard
facebookButton.Size = UDim2.new(0, 112, 0, 30)
facebookButton.Position = UDim2.new(1, -126, 0.5, -15)
facebookButton.BackgroundColor3 = accent()
facebookButton.BorderSizePixel = 0
facebookButton.AutoButtonColor = false
facebookButton.Text = "ADD FACEBOOK"
facebookButton.Font = Enum.Font.GothamBold
facebookButton.TextSize = 10
facebookButton.TextColor3 = Color3.fromRGB(24, 27, 34)
facebookButton.ZIndex = 5
corner(facebookButton, 7)
local facebookStroke = stroke(facebookButton, accent(), 1, 0.1)

facebookButton.MouseEnter:Connect(function()
    facebookButton.BackgroundColor3 = accent():Lerp(Color3.new(1, 1, 1), 0.10)
end)
facebookButton.MouseLeave:Connect(function()
    facebookButton.BackgroundColor3 = accent()
end)
facebookButton.Activated:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(FACEBOOK_URL)
        end
    end)
    notify("Facebook link copied successfully!")
end)

-- Keep accents synced with the Main theme/Rainbow engine.
task.spawn(function()
    while tab.Parent do
        local c = accent()
        username.TextColor3 = c
        -- Logo icons stay neutral; the Main theme is intentionally not applied to them.
        discordIcon.TextColor3 = Color3.fromRGB(210, 214, 224)
        facebookIcon.TextColor3 = Color3.fromRGB(210, 214, 224)
        discordButton.BackgroundColor3 = c
        facebookButton.BackgroundColor3 = c
        discordStroke.Color = c
        facebookStroke.Color = c
        task.wait(0.08)
    end
end)
