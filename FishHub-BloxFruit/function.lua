local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

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
    tab = contentContainer and contentContainer:FindFirstChild("FunctionTab", true)
end

if not tab then return end

for _, child in ipairs(tab:GetChildren()) do
    child:Destroy()
end

local main = (context and context.MainWindow) or fishHub:FindFirstChild("MainWindow")
local function theme()
    local stroke = main and main:FindFirstChildOfClass("UIStroke")
    return stroke and stroke.Color or Color3.fromRGB(0, 229, 255)
end

local search = Instance.new("TextBox")
search.Size = UDim2.new(1, -8, 0, 34)
search.Position = UDim2.new(0, 4, 0, 4)
search.BackgroundColor3 = Color3.fromRGB(8, 9, 13)
search.BackgroundTransparency = 0.05
search.BorderSizePixel = 0
search.Font = Enum.Font.GothamMedium
search.TextSize = 11
search.TextColor3 = Color3.fromRGB(235, 238, 245)
search.PlaceholderColor3 = Color3.fromRGB(125, 130, 145)
search.PlaceholderText = "search..."
search.Text = ""
search.ClearTextOnFocus = false
search.Parent = tab

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = search

local searchStroke = Instance.new("UIStroke")
searchStroke.Color = theme()
searchStroke.Transparency = 0.5
searchStroke.Parent = search

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0.5, -7, 0, 82)
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.Parent = tab

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 50)
padding.PaddingLeft = UDim.new(0, 4)
padding.PaddingRight = UDim.new(0, 4)
padding.PaddingBottom = UDim.new(0, 8)
padding.Parent = tab

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

local function createCard(name)
    local card = Instance.new("TextButton")
    card.Name = name:gsub("%W", "") .. "Card"
    card.BackgroundColor3 = Color3.fromRGB(8, 9, 13)
    card.BackgroundTransparency = 0.04
    card.BorderSizePixel = 0
    card.AutoButtonColor = false
    card.Text = ""
    card.Parent = tab

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = theme()
    stroke.Transparency = 0.52
    stroke.Thickness = 1
    stroke.Parent = card

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 11)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextColor3 = Color3.fromRGB(240, 242, 248)
    title.Text = name
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -20, 0, 25)
    desc.Position = UDim2.new(0, 10, 0, 38)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.Code
    desc.TextSize = 9
    desc.TextColor3 = Color3.fromRGB(120, 125, 140)
    desc.Text = "Function content"
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = card

    card.MouseEnter:Connect(function()
        card.BackgroundColor3 = Color3.fromRGB(16, 17, 24)
        stroke.Transparency = 0.1
    end)

    card.MouseLeave:Connect(function()
        card.BackgroundColor3 = Color3.fromRGB(8, 9, 13)
        stroke.Transparency = 0.52
    end)

    card.MouseButton1Click:Connect(function()
        desc.Text = "Ready • " .. name
    end)

    cards[#cards + 1] = {button = card, name = name}
end

for _, name in ipairs(names) do
    createCard(name)
end

search:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(search.Text)
    for _, item in ipairs(cards) do
        item.button.Visible = query == "" or string.find(string.lower(item.name), query, 1, true) ~= nil
    end
end)
