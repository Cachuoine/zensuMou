-- URL: https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/function.lua
return function(tabFrame)
    for _, child in ipairs(tabFrame:GetChildren()) do
        child:Destroy()
    end

    local layout = Instance.new("UIListLayout")
    layout.Parent = tabFrame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 320)

    -- 1. Search Bar
    local searchBox = Instance.new("TextBox")
    searchBox.Parent = tabFrame
    searchBox.Size = UDim2.new(1, -20, 0, 34)
    searchBox.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
    searchBox.BorderSizePixel = 0
    searchBox.Font = Enum.Font.GothamMedium
    searchBox.TextSize = 12
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.PlaceholderText = "search..."
    searchBox.Text = ""
    searchBox.LayoutOrder = 1
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)

    -- 2. Function Cards
    local functionsList = {"shop", "setting farm", "farm", "item & quest", "island", "fruit", "setiing"}
    
    for i, funcName in ipairs(functionsList) do
        local card = Instance.new("TextButton")
        card.Parent = tabFrame
        card.Size = UDim2.new(1, -20, 0, 34)
        card.BackgroundColor3 = Color3.fromRGB(45, 47, 58)
        card.BorderSizePixel = 0
        card.AutoButtonColor = false
        card.Font = Enum.Font.GothamBold
        card.TextSize = 12
        card.TextColor3 = Color3.fromRGB(240, 240, 250)
        card.Text = "⚡ " .. funcName:upper()
        card.LayoutOrder = i + 1
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

        card.MouseButton1Click:Connect(function()
            print("Triggered function: " .. funcName)
        end)
    end
end
