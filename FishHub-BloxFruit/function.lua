local tab = ...
if not tab then return end

local layout = Instance.new("UIListLayout")
layout.Parent = tab
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 1. Search Bar
local searchBox = Instance.new("TextBox")
searchBox.Parent = tab
searchBox.Size = UDim2.new(1, -20, 0, 35)
searchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
searchBox.BorderSizePixel = 0
searchBox.PlaceholderText = "search..."
searchBox.Text = ""
searchBox.Font = Enum.Font.GothamMedium
searchBox.TextSize = 12
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 8)

local functionsList = {"shop", "setting farm", "farm", "item & quest", "island", "fruit", "setiing"}
local cardFrames = {}

for _, funcName in ipairs(functionsList) do
    local card = Instance.new("Frame")
    card.Name = funcName
    card.Parent = tab
    card.Size = UDim2.new(1, -20, 0, 40)
    card.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel")
    label.Parent = card
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Text = funcName:upper()
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    table.insert(cardFrames, {Card = card, Name = funcName})
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = searchBox.Text:lower()
    for _, item in ipairs(cardFrames) do
        if query == "" or string.find(item.Name, query) then
            item.Card.Visible = true
        else
            item.Card.Visible = false
        end
    end
end)
