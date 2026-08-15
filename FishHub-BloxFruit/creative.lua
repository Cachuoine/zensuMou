local Players = game:GetService("Players")

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
    tab = contentContainer and contentContainer:FindFirstChild("CreativeTab", true)
end

if not tab then return end

for _, child in ipairs(tab:GetChildren()) do
    child:Destroy()
end

local function theme()
    local main = (context and context.MainWindow) or fishHub:FindFirstChild("MainWindow")
    local stroke = main and main:FindFirstChildOfClass("UIStroke")
    return stroke and stroke.Color or Color3.fromRGB(0, 229, 255)
end

local function makeSection(titleText, height)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -8, 0, height)
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.Parent = tab

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 1)
    top.Position = UDim2.new(0, 0, 0, 15)
    top.BackgroundColor3 = theme()
    top.BorderSizePixel = 0
    top.Parent = holder

    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.2, 0.55),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.8, 0.55),
        NumberSequenceKeypoint.new(1, 0.9)
    })
    gradient.Parent = top

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 180, 0, 30)
    label.Position = UDim2.new(0.5, -90, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = theme()
    label.Text = titleText
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Parent = holder

    local bottom = top:Clone()
    bottom.Position = UDim2.new(0, 0, 1, -1)
    bottom.Parent = holder

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -20, 1, -46)
    card.Position = UDim2.new(0, 10, 0, 30)
    card.BackgroundColor3 = Color3.fromRGB(8, 9, 13)
    card.BackgroundTransparency = 0.05
    card.BorderSizePixel = 0
    card.Parent = holder

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = theme()
    stroke.Transparency = 0.55
    stroke.Parent = card

    return card
end

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 12)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = tab

local robloxCard = makeSection("ROBLOX PLAYERS", 118)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 54, 0, 54)
avatar.Position = UDim2.new(0, 12, 0, 10)
avatar.BackgroundColor3 = Color3.fromRGB(18, 20, 27)
avatar.BorderSizePixel = 0
avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
avatar.Parent = robloxCard

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = avatar

local display = Instance.new("TextLabel")
display.Size = UDim2.new(1, -82, 0, 24)
display.Position = UDim2.new(0, 78, 0, 10)
display.BackgroundTransparency = 1
display.Font = Enum.Font.GothamBold
display.TextSize = 13
display.TextColor3 = Color3.fromRGB(245, 245, 250)
display.Text = player.DisplayName
display.TextXAlignment = Enum.TextXAlignment.Left
display.Parent = robloxCard

local user = display:Clone()
user.Position = UDim2.new(0, 78, 0, 35)
user.TextSize = 10
user.Font = Enum.Font.GothamMedium
user.TextColor3 = Color3.fromRGB(150, 155, 170)
user.Text = "@" .. player.Name
user.Parent = robloxCard

local facebookCard = makeSection("FACEBOOK PLAYERS", 96)

local add = Instance.new("TextButton")
add.Size = UDim2.new(1, -20, 0, 36)
add.Position = UDim2.new(0, 10, 0.5, -18)
add.BackgroundColor3 = theme()
add.BorderSizePixel = 0
add.AutoButtonColor = false
add.Font = Enum.Font.GothamBold
add.TextSize = 11
add.TextColor3 = Color3.fromRGB(20, 20, 28)
add.Text = "ADD"
add.Parent = facebookCard

local addCorner = Instance.new("UICorner")
addCorner.CornerRadius = UDim.new(0, 7)
addCorner.Parent = add

local facebookUrl = "https://www.facebook.com/dao.huy.lam.09/"

add.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(facebookUrl)
        end
    end)
    add.Text = "COPIED FACEBOOK LINK"
    task.delay(1.5, function()
        if add and add.Parent then
            add.Text = "ADD"
        end
    end)
end)
