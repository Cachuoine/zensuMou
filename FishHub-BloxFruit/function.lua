
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
    tab = content and content:FindFirstChild("FunctionTab", true)
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

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "FunctionScroll"
scroll.Size = UDim2.new(1,0,1,0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 0
scroll.ScrollBarImageTransparency = 1
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = tab

local root = Instance.new("Frame")
root.Name = "FunctionContent"
root.Size = UDim2.new(1, -10, 0, 430)
root.BackgroundTransparency = 1
root.Parent = scroll

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 12)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = root

local searchWrap = Instance.new("Frame")
searchWrap.LayoutOrder = 1
searchWrap.Size = UDim2.new(1, -4, 0, 48)
searchWrap.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
searchWrap.BorderSizePixel = 0
searchWrap.Parent = root

local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, 10)
c.Parent = searchWrap

local s = Instance.new("UIStroke")
s.Color = theme()
s.Transparency = 0.55
s.Parent = searchWrap

local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 34, 1, 0)
icon.Position = UDim2.new(0, 7, 0, 0)
icon.BackgroundTransparency = 1
icon.Font = Enum.Font.GothamBold
icon.TextSize = 14
icon.TextColor3 = theme()
icon.Text = "⌘"
icon.Parent = searchWrap

local search = Instance.new("TextBox")
search.Size = UDim2.new(1, -52, 1, 0)
search.Position = UDim2.new(0, 45, 0, 0)
search.BackgroundTransparency = 1
search.BorderSizePixel = 0
search.Font = Enum.Font.GothamMedium
search.TextSize = 11
search.TextColor3 = Color3.fromRGB(235, 238, 245)
search.PlaceholderColor3 = Color3.fromRGB(105, 110, 125)
search.PlaceholderText = "search..."
search.Text = ""
search.ClearTextOnFocus = false
search.TextXAlignment = Enum.TextXAlignment.Left
search.Parent = searchWrap

local gridHolder = Instance.new("Frame")
gridHolder.LayoutOrder = 2
gridHolder.Size = UDim2.new(1, -4, 0, 360)
gridHolder.BackgroundTransparency = 1
gridHolder.Parent = root

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0.5, -6, 0, 82)
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.Parent = gridHolder

local names = {
    "shop",
    "setting farm",
    "farm",
    "item & quest",
    "island",
    "fruit",
    "setiing"
}

local cards = {}

local function createCard(name, order)
    local card = Instance.new("TextButton")
    card.LayoutOrder = order
    card.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
    card.BorderSizePixel = 0
    card.AutoButtonColor = false
    card.Text = ""
    card.Parent = gridHolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = theme()
    stroke.Transparency = 0.6
    stroke.Parent = card

    local number = Instance.new("TextLabel")
    number.Size = UDim2.new(0, 30, 0, 24)
    number.Position = UDim2.new(0, 11, 0, 9)
    number.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
    number.BorderSizePixel = 0
    number.Font = Enum.Font.GothamBold
    number.TextSize = 8
    number.TextColor3 = theme()
    number.Text = string.format("%02d", order)
    number.Parent = card

    local nc = Instance.new("UICorner")
    nc.CornerRadius = UDim.new(0, 6)
    nc.Parent = number

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -56, 0, 24)
    title.Position = UDim2.new(0, 50, 0, 9)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextColor3 = Color3.fromRGB(240, 242, 248)
    title.Text = name
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -20, 0, 20)
    sub.Position = UDim2.new(0, 10, 0, 43)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.GothamMedium
    sub.TextSize = 8
    sub.TextColor3 = Color3.fromRGB(105, 110, 125)
    sub.Text = "FUNCTION • READY"
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = card

    card.MouseEnter:Connect(function()
        card.BackgroundColor3 = Color3.fromRGB(13, 14, 21)
        stroke.Transparency = 0.18
    end)

    card.MouseLeave:Connect(function()
        card.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
        stroke.Transparency = 0.6
    end)

    cards[#cards + 1] = {
        button = card,
        name = string.lower(name)
    }
end

for i, name in ipairs(names) do
    createCard(name, i)
end

search:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(search.Text)
    for _, item in ipairs(cards) do
        item.button.Visible = query == "" or string.find(item.name, query, 1, true) ~= nil
    end
end)
