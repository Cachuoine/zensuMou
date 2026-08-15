local Players = game:GetService("Players")

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
    tab = content and content:FindFirstChild("CreativeTab", true)
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

local root = Instance.new("Frame")
root.Name = "CreativeContent"
root.Size = UDim2.new(1, -10, 0, 300)
root.BackgroundTransparency = 1
root.Parent = tab

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 14)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = root

local function section(titleText, height, order)
    local holder = Instance.new("Frame")
    holder.LayoutOrder = order
    holder.Size = UDim2.new(1, -4, 0, height)
    holder.BackgroundTransparency = 1
    holder.Parent = root

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 200, 0, 20)
    title.Position = UDim2.new(0.5, -100, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextColor3 = theme()
    title.Text = titleText
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = holder

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0, 25)
    line.BackgroundColor3 = theme()
    line.BorderSizePixel = 0
    line.Parent = holder

    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.94),
        NumberSequenceKeypoint.new(0.18, 0.6),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.82, 0.6),
        NumberSequenceKeypoint.new(1, 0.94)
    })
    gradient.Parent = line

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, height - 42)
    card.Position = UDim2.new(0, 4, 0, 39)
    card.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
    card.BorderSizePixel = 0
    card.Parent = holder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = theme()
    stroke.Transparency = 0.62
    stroke.Parent = card

    return card
end

local roblox = section("ROBLOX PLAYERS", 132, 1)

local targetUsername = "thanhhuyenhuy"
local targetUserId
local targetDisplayName = targetUsername

pcall(function()
    targetUserId = Players:GetUserIdFromNameAsync(targetUsername)
end)

if targetUserId then
    pcall(function()
        targetDisplayName = Players:GetNameFromUserIdAsync(targetUserId)
    end)
end

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 68, 0, 68)
avatar.Position = UDim2.new(0, 14, 0, 13)
avatar.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
avatar.BorderSizePixel = 0
if targetUserId then
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(targetUserId) .. "&w=150&h=150"
end
avatar.Parent = roblox

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(0, 11)
avatarCorner.Parent = avatar

local name = Instance.new("TextLabel")
name.Size = UDim2.new(1, -100, 0, 24)
name.Position = UDim2.new(0, 96, 0, 14)
name.BackgroundTransparency = 1
name.Font = Enum.Font.GothamBold
name.TextSize = 14
name.TextColor3 = Color3.fromRGB(245, 246, 252)
name.Text = targetDisplayName
name.TextXAlignment = Enum.TextXAlignment.Left
name.Parent = roblox

local username = Instance.new("TextLabel")
username.Size = UDim2.new(1, -100, 0, 22)
username.Position = UDim2.new(0, 96, 0, 40)
username.BackgroundTransparency = 1
username.Font = Enum.Font.GothamBold
username.TextSize = 10
username.TextColor3 = theme()
username.Text = "@" .. targetUsername
username.TextXAlignment = Enum.TextXAlignment.Left
username.Parent = roblox

local ownerTag = Instance.new("TextLabel")
ownerTag.Size = UDim2.new(1, -28, 0, 20)
ownerTag.Position = UDim2.new(0, 14, 0, 88)
ownerTag.BackgroundTransparency = 1
ownerTag.Font = Enum.Font.GothamMedium
ownerTag.TextSize = 8
ownerTag.TextColor3 = Color3.fromRGB(105, 110, 125)
ownerTag.Text = "ROBLOX PROFILE • @" .. targetUsername
ownerTag.TextXAlignment = Enum.TextXAlignment.Left
ownerTag.Parent = roblox

local facebook = section("FACEBOOK PLAYERS", 116, 2)

local fbTitle = Instance.new("TextLabel")
fbTitle.Size = UDim2.new(1, -28, 0, 22)
fbTitle.Position = UDim2.new(0, 14, 0, 9)
fbTitle.BackgroundTransparency = 1
fbTitle.Font = Enum.Font.GothamBold
fbTitle.TextSize = 10
fbTitle.TextColor3 = Color3.fromRGB(230, 232, 240)
fbTitle.Text = "Facebook profile"
fbTitle.TextXAlignment = Enum.TextXAlignment.Left
fbTitle.Parent = facebook

local fbUrl = "https://www.facebook.com/dao.huy.lam.09/"

local add = Instance.new("TextButton")
add.Size = UDim2.new(1, -28, 0, 38)
add.Position = UDim2.new(0, 14, 0, 39)
add.BackgroundColor3 = theme()
add.BorderSizePixel = 0
add.AutoButtonColor = false
add.Font = Enum.Font.GothamBold
add.TextSize = 10
add.TextColor3 = Color3.fromRGB(18, 18, 25)
add.Text = "ADD  •  FACEBOOK"
add.Parent = facebook

local addCorner = Instance.new("UICorner")
addCorner.CornerRadius = UDim.new(0, 8)
addCorner.Parent = add

local link = Instance.new("TextLabel")
link.Size = UDim2.new(1, -28, 0, 18)
link.Position = UDim2.new(0, 14, 0, 81)
link.BackgroundTransparency = 1
link.Font = Enum.Font.GothamMedium
link.TextSize = 8
link.TextColor3 = Color3.fromRGB(105, 110, 125)
link.Text = "dao.huy.lam.09"
link.TextXAlignment = Enum.TextXAlignment.Left
link.Parent = facebook

add.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(fbUrl)
        end
    end)
    add.Text = "COPIED  •  FACEBOOK LINK"
    task.delay(1.6, function()
        if add.Parent then
            add.Text = "ADD  •  FACEBOOK"
        end
    end)
end)
