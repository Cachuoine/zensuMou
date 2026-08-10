--[[
    ESP - FishHub standalone module

    This module owns its own UI. FishHub only launches this file.
    Search and Back are intentionally kept here, not in FishHub.lua.

    NOTE: The current remote repository files were found to be empty (0 bytes).
    This standalone shell avoids inventing unknown game-specific remotes.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local GUI_NAME = "FishHub_esplua"

local old = PlayerGui:FindFirstChild(GUI_NAME)
if old then old:Destroy() end

local Accent = Color3.fromRGB(0, 229, 255)
local BG = Color3.fromRGB(10, 10, 13)
local CARD = Color3.fromRGB(18, 18, 23)
local TEXT = Color3.fromRGB(245, 245, 250)
local MUTED = Color3.fromRGB(160, 165, 180)

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(520, 430)
main.Position = UDim2.new(0.5, -260, 0.5, -215)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Accent
stroke.Thickness = 1.2

local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1, -110, 0, 44)
title.Position = UDim2.fromOffset(18, 8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextColor3 = TEXT
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "👁️  ESP"

local back = Instance.new("TextButton")
back.Parent = main
back.Size = UDim2.fromOffset(72, 30)
back.Position = UDim2.new(1, -86, 0, 15)
back.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
back.BorderSizePixel = 0
back.Text = "BACK"
back.Font = Enum.Font.GothamBold
back.TextSize = 11
back.TextColor3 = TEXT
Instance.new("UICorner", back).CornerRadius = UDim.new(0, 7)

local searchCard = Instance.new("Frame")
searchCard.Parent = main
searchCard.Size = UDim2.new(1, -36, 0, 38)
searchCard.Position = UDim2.fromOffset(18, 58)
searchCard.BackgroundColor3 = CARD
searchCard.BorderSizePixel = 0
Instance.new("UICorner", searchCard).CornerRadius = UDim.new(0, 8)
local searchStroke = Instance.new("UIStroke", searchCard)
searchStroke.Color = Accent
searchStroke.Thickness = 1

local searchIcon = Instance.new("TextLabel")
searchIcon.Parent = searchCard
searchIcon.Size = UDim2.fromOffset(30, 38)
searchIcon.BackgroundTransparency = 1
searchIcon.Text = "🔍"
searchIcon.TextSize = 14
searchIcon.Font = Enum.Font.GothamBold

local search = Instance.new("TextBox")
search.Parent = searchCard
search.Size = UDim2.new(1, -40, 1, 0)
search.Position = UDim2.fromOffset(35, 0)
search.BackgroundTransparency = 1
search.TextColor3 = TEXT
search.PlaceholderColor3 = MUTED
search.PlaceholderText = "Search features..."
search.Text = ""
search.ClearTextOnFocus = false
search.Font = Enum.Font.Gotham
search.TextSize = 12
search.TextXAlignment = Enum.TextXAlignment.Left

local content = Instance.new("ScrollingFrame")
content.Parent = main
content.Size = UDim2.new(1, -36, 1, -115)
content.Position = UDim2.fromOffset(18, 105)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 2
content.ScrollBarImageColor3 = Accent
content.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout")
layout.Parent = content
layout.Padding = UDim.new(0, 9)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function addCard(name, description, order)
    local card = Instance.new("Frame")
    card.Name = name
    card.Size = UDim2.new(1, -4, 0, 62)
    card.BackgroundColor3 = CARD
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.Parent = content
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 9)

    local s = Instance.new("UIStroke", card)
    s.Color = Color3.fromRGB(55, 55, 65)
    s.Thickness = 1

    local n = Instance.new("TextLabel")
    n.Parent = card
    n.Size = UDim2.new(1, -20, 0, 22)
    n.Position = UDim2.fromOffset(10, 7)
    n.BackgroundTransparency = 1
    n.Font = Enum.Font.GothamBold
    n.TextSize = 12
    n.TextColor3 = TEXT
    n.TextXAlignment = Enum.TextXAlignment.Left
    n.Text = name

    local d = Instance.new("TextLabel")
    d.Parent = card
    d.Size = UDim2.new(1, -20, 0, 26)
    d.Position = UDim2.fromOffset(10, 29)
    d.BackgroundTransparency = 1
    d.Font = Enum.Font.Gotham
    d.TextSize = 10
    d.TextColor3 = MUTED
    d.TextWrapped = true
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.Text = description

    return card
end

local cards = {}
local featureList = {
    {"ESP controls", "Player / item / chest visual controls"},
    {"Search", "Filter this module's controls using the search bar above."},
    {"Back", "Close this module and return to the FishHub window."},
}

for i, feature in ipairs(featureList) do
    cards[i] = addCard(feature[1], feature[2], i)
end

search:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(search.Text or "")
    for _, card in ipairs(cards) do
        card.Visible = q == "" or string.find(string.lower(card.Name), q, 1, true) ~= nil
    end
end)

back.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Escape and gui.Parent then
        gui:Destroy()
    end
end)

print("[FishHub] ESP standalone module loaded")
