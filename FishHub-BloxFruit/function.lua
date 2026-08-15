return function(ctx)
    local Container = ctx.Container
    local Theme = ctx.ThemeColor()
    local Text = ctx.Config.Text
    local Muted = ctx.Config.Muted
    local Card = ctx.Config.Card
    local Inner = ctx.Config.Inner

    local Search = Instance.new("TextBox")
    Search.Parent = Container
    Search.Size = UDim2.new(1, -12, 0, 38)
    Search.BackgroundColor3 = Inner
    Search.BorderSizePixel = 0
    Search.ClearTextOnFocus = false
    Search.PlaceholderText = "search..."
    Search.PlaceholderColor3 = Muted
    Search.Text = ""
    Search.TextColor3 = Text
    Search.Font = Enum.Font.GothamMedium
    Search.TextSize = 10
    Search.TextXAlignment = Enum.TextXAlignment.Left
    Search.Parent = Container

    local searchPadding = Instance.new("UIPadding")
    searchPadding.Parent = Search
    searchPadding.PaddingLeft = UDim.new(0, 12)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = Search

    local searchStroke = Instance.new("UIStroke")
    searchStroke.Parent = Search
    searchStroke.Color = Theme
    searchStroke.Transparency = 0.45

    local Grid = Instance.new("Frame")
    Grid.Parent = Container
    Grid.Size = UDim2.new(1, -12, 0, 180)
    Grid.BackgroundTransparency = 1

    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.Parent = Grid
    gridLayout.CellSize = UDim2.new(0.5, -6, 0, 50)
    gridLayout.CellPadding = UDim2.fromOffset(8, 8)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local names = {
        "Shop",
        "Setting Farm",
        "Farm",
        "Item & Quest",
        "Island",
        "Fruit",
        "Setting"
    }

    local cards = {}

    local function createFunction(name)
        local button = Instance.new("TextButton")
        button.Parent = Grid
        button.BackgroundColor3 = Card
        button.BorderSizePixel = 0
        button.AutoButtonColor = false
        button.Text = name
        button.Font = Enum.Font.GothamBold
        button.TextSize = 10
        button.TextColor3 = Text
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke")
        stroke.Parent = button
        stroke.Color = Theme
        stroke.Transparency = 0.5

        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Theme
            button.TextColor3 = Color3.fromRGB(20, 22, 28)
        end)

        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = Card
            button.TextColor3 = Text
        end)

        button.MouseButton1Click:Connect(function()
            ctx.Notify(name .. " selected")
        end)

        cards[#cards + 1] = {
            Name = string.lower(name),
            Button = button
        }
    end

    for _, name in ipairs(names) do
        createFunction(name)
    end

    Search:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(Search.Text)

        for _, item in ipairs(cards) do
            item.Button.Visible = query == "" or string.find(item.Name, query, 1, true) ~= nil
        end
    end)
end
