-- Function.lua
-- FishHub modular tab content.
-- This file returns a renderer function consumed by UI.lua.

return function(C, tabFrame)
    local Config = C.Config
    local TweenService = C.TweenService
    local Players = C.Players
    local Player = C.Player
    local TeleportService = C.TeleportService
    local ShowNotification = C.ShowNotification
    local AddHoverGlow = C.AddHoverGlow
    local GetCurrentAccentColor = C.GetCurrentAccentColor
    local allHubStrokes = C.allHubStrokes
    local allHubLines = C.allHubLines
    local allThemeTexts = C.allThemeTexts
    local contentContainer = C.contentContainer
    local game = C.game
    local Instance = C.Instance
    local Enum = C.Enum
    local UDim = C.UDim
    local UDim2 = C.UDim2
    local Color3 = C.Color3


        local mainFunctionContainer = Instance.new("Frame")
        mainFunctionContainer.Parent = tabFrame
        mainFunctionContainer.Size = UDim2.new(1, 0, 1, 0)
        mainFunctionContainer.BackgroundTransparency = 1

        local searchBarCard = Instance.new("Frame")
        searchBarCard.Parent = mainFunctionContainer
        searchBarCard.Size = UDim2.new(1, 0, 0, 38)
        searchBarCard.BackgroundColor3 = Config.BgCard
        searchBarCard.BackgroundTransparency = 0.2
        searchBarCard.BorderSizePixel = 0
        Instance.new("UICorner", searchBarCard).CornerRadius = UDim.new(0, 8)
        local searchStroke = Instance.new("UIStroke")
        searchStroke.Parent = searchBarCard
        searchStroke.Color = Config.ThemeColor
        searchStroke.Thickness = 1
        table.insert(allHubStrokes, searchStroke)
        AddHoverGlow(searchBarCard, searchStroke)

        local searchIcon = Instance.new("TextLabel")
        searchIcon.Parent = searchBarCard
        searchIcon.Size = UDim2.new(0, 30, 1, 0)
        searchIcon.Position = UDim2.new(0, 6, 0, 0)
        searchIcon.BackgroundTransparency = 1
        searchIcon.Font = Enum.Font.GothamBold
        searchIcon.TextSize = 14
        searchIcon.Text = "🔍"
        searchIcon.TextXAlignment = Enum.TextXAlignment.Center

        local searchBox = Instance.new("TextBox")
        searchBox.Parent = searchBarCard
        searchBox.Size = UDim2.new(1, -42, 1, 0)
        searchBox.Position = UDim2.new(0, 38, 0, 0)
        searchBox.BackgroundTransparency = 1
        searchBox.Font = Enum.Font.Gotham
        searchBox.TextSize = 13
        searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
        searchBox.PlaceholderText = "search..."
        searchBox.Text = ""
        searchBox.ClearTextOnFocus = false

        local gridMenu = Instance.new("ScrollingFrame")
        gridMenu.Parent = mainFunctionContainer
        gridMenu.Size = UDim2.new(1, 0, 1, -48)
        gridMenu.Position = UDim2.new(0, 0, 0, 48)
        gridMenu.BackgroundTransparency = 1
        gridMenu.BorderSizePixel = 0
        gridMenu.ScrollBarThickness = 0

        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.Parent = gridMenu
        gridLayout.CellSize = UDim2.new(0.5, -6, 0, 80)
        gridLayout.CellPadding = UDim2.new(0, 12, 0, 12)
        gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local subPagesContainer = Instance.new("Frame")
        subPagesContainer.Parent = mainFunctionContainer
        subPagesContainer.Size = UDim2.new(1, 0, 1, 0)
        subPagesContainer.BackgroundTransparency = 1
        subPagesContainer.Visible = false

        local subPageTitle = Instance.new("TextLabel")
        subPageTitle.Parent = subPagesContainer
        subPageTitle.Size = UDim2.new(1, -215, 0, 35)
        subPageTitle.Position = UDim2.new(0, 0, 0, 0)
        subPageTitle.BackgroundTransparency = 1
        subPageTitle.Font = Enum.Font.GothamBold
        subPageTitle.TextSize = 16
        subPageTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        subPageTitle.TextXAlignment = Enum.TextXAlignment.Left

        -- Đã sửa: Thanh search nhỏ và nút Back nằm cạnh bên phải
        local subSearchBarCard = Instance.new("Frame")
        subSearchBarCard.Parent = subPagesContainer
        subSearchBarCard.Size = UDim2.new(0, 110, 0, 32)
        subSearchBarCard.Position = UDim2.new(1, -205, 0, 1)
        subSearchBarCard.BackgroundColor3 = Config.BgCard
        subSearchBarCard.BackgroundTransparency = 0.2
        subSearchBarCard.BorderSizePixel = 0
        Instance.new("UICorner", subSearchBarCard).CornerRadius = UDim.new(0, 6)
        local subSearchStroke = Instance.new("UIStroke")
        subSearchStroke.Parent = subSearchBarCard
        subSearchStroke.Color = Config.ThemeColor
        subSearchStroke.Thickness = 1
        table.insert(allHubStrokes, subSearchStroke)
        AddHoverGlow(subSearchBarCard, subSearchStroke)

        local subSearchIcon = Instance.new("TextLabel")
        subSearchIcon.Parent = subSearchBarCard
        subSearchIcon.Size = UDim2.new(0, 22, 1, 0)
        subSearchIcon.Position = UDim2.new(0, 4, 0, 0)
        subSearchIcon.BackgroundTransparency = 1
        subSearchIcon.Font = Enum.Font.GothamBold
        subSearchIcon.TextSize = 12
        subSearchIcon.Text = "🔍"
        subSearchIcon.TextXAlignment = Enum.TextXAlignment.Center

        local subSearchBox = Instance.new("TextBox")
        subSearchBox.Parent = subSearchBarCard
        subSearchBox.Size = UDim2.new(1, -28, 1, 0)
        subSearchBox.Position = UDim2.new(0, 26, 0, 0)
        subSearchBox.BackgroundTransparency = 1
        subSearchBox.Font = Enum.Font.Gotham
        subSearchBox.TextSize = 11
        subSearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        subSearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
        subSearchBox.PlaceholderText = "search..."
        subSearchBox.Text = ""
        subSearchBox.ClearTextOnFocus = false

        local backButton = Instance.new("TextButton")
        backButton.Parent = subPagesContainer
        backButton.Size = UDim2.new(0, 90, 0, 32)
        backButton.Position = UDim2.new(1, -90, 0, 1)
        backButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        backButton.BorderSizePixel = 0
        backButton.Text = "Back"
        backButton.Font = Enum.Font.GothamBold
        backButton.TextSize = 12
        backButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", backButton).CornerRadius = UDim.new(0, 6)
        local backStroke = Instance.new("UIStroke")
        backStroke.Parent = backButton
        backStroke.Color = Config.ThemeColor
        backStroke.Thickness = 1
        table.insert(allHubStrokes, backStroke)
        AddHoverGlow(backButton, backStroke)

        local subPageContentText = Instance.new("TextLabel")
        subPageContentText.Parent = subPagesContainer
        subPageContentText.Size = UDim2.new(1, 0, 1, -45)
        subPageContentText.Position = UDim2.new(0, 0, 0, 45)
        subPageContentText.BackgroundTransparency = 1
        subPageContentText.Font = Enum.Font.Gotham
        subPageContentText.TextSize = 13
        subPageContentText.TextColor3 = Color3.fromRGB(200, 200, 210)
        subPageContentText.TextXAlignment = Enum.TextXAlignment.Left
        subPageContentText.TextYAlignment = Enum.TextYAlignment.Top
        subPageContentText.TextWrapped = true

        backButton.MouseButton1Click:Connect(function()
            subPagesContainer.Visible = false
            searchBarCard.Visible = true
            gridMenu.Visible = true
        end)

        local cardList = {}
        local function CreateCategoryCard(title, icon, desc, order)
            local card = Instance.new("TextButton")
            card.Parent = gridMenu
            card.BackgroundColor3 = Config.BgCard
            card.BackgroundTransparency = 0.2
            card.BorderSizePixel = 0
            card.AutoButtonColor = false
            card.Text = ""
            card.LayoutOrder = order
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
            
            local stroke = Instance.new("UIStroke")
            stroke.Parent = card
            stroke.Color = Config.ThemeColor
            stroke.Thickness = 1.5
            table.insert(allHubStrokes, stroke)

            local iconLbl = Instance.new("TextLabel")
            iconLbl.Parent = card
            iconLbl.Size = UDim2.new(0, 42, 0, 42)
            iconLbl.Position = UDim2.new(0, 12, 0.5, -21)
            iconLbl.BackgroundTransparency = 1
            iconLbl.Font = Enum.Font.GothamBold
            iconLbl.TextSize = 24
            iconLbl.Text = icon
            iconLbl.TextXAlignment = Enum.TextXAlignment.Center

            local titleLbl = Instance.new("TextLabel")
            titleLbl.Parent = card
            titleLbl.Size = UDim2.new(1, -62, 0, 22)
            titleLbl.Position = UDim2.new(0, 58, 0, 16)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Font = Enum.Font.GothamBold
            titleLbl.TextSize = 14
            titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLbl.Text = title
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left

            local descLbl = Instance.new("TextLabel")
            descLbl.Parent = card
            descLbl.Size = UDim2.new(1, -62, 0, 24)
            descLbl.Position = UDim2.new(0, 58, 0, 38)
            descLbl.BackgroundTransparency = 1
            descLbl.Font = Enum.Font.Gotham
            descLbl.TextSize = 12
            descLbl.TextColor3 = Color3.fromRGB(170, 170, 190)
            descLbl.Text = desc
            descLbl.TextXAlignment = Enum.TextXAlignment.Left
            descLbl.TextWrapped = true

            AddHoverGlow(card, stroke)

            card.MouseEnter:Connect(function()
                TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Color3.fromRGB(70, 70, 85),
                    BackgroundTransparency = 0.05
                }):Play()
                TweenService:Create(titleLbl, TweenInfo.new(0.25), {
                    TextColor3 = GetCurrentAccentColor()
                }):Play()
            end)

            card.MouseLeave:Connect(function()
                TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Config.BgCard,
                    BackgroundTransparency = 0.2
                }):Play()
                TweenService:Create(titleLbl, TweenInfo.new(0.25), {
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
            end)

            card.MouseButton1Click:Connect(function()
                subPageTitle.Text = icon .. "  Content: " .. title
                -- Khôi phục lại nội dung chi tiết riêng biệt cho từng ô function
                if title == "Shop" then
                    subPageContentText.Text = "• Auto Buy Items & Swords\n• Auto Buy Haki & Abilities\n• Shop Black Market Options\n\n(Select the specific options above to execute automated purchasing.)"
                elseif title == "Setting farm" then
                    subPageContentText.Text = "• Fast Attack Options\n• Select Weapon Type (Melee/Sword/Gun/Fruit)\n• Safe HP Settings & Auto V3/V4"
                elseif title == "Farm" then
                    subPageContentText.Text = "• Auto Farm Level (Optimized & Fast)\n• Auto Quest & Boss Farmer\n• Auto Bone / Material Farming"
                elseif title == "Item and Quest" then
                    subPageContentText.Text = "• Auto Second Sea / Third Sea Quests\n• Auto Collect Chests & Materials\n• Auto Saber / Rengoku / Cursed Dual Katana"
                elseif title == "Teleport Island" then
                    subPageContentText.Text = "• Quick Teleport to All Sea 1/2/3 Islands\n• Teleport to NPC / Raid / Factory\n• Custom Waypoint Teleports"
                elseif title == "Fruit" then
                    subPageContentText.Text = "• Auto Sniping / Collecting Spawned Fruits\n• Random Fruit Purchase & Storage\n• Auto Eat / Store Devil Fruits"
                elseif title == "ESP" then
                    subPageContentText.Text = "• ESP Players (Name, Distance, Health)\n• ESP Chests & Flowers\n• ESP Devil Fruits & Raids"
                elseif title == "Setting" then
                    subPageContentText.Text = "• Hub Customization & FPS Boost\n• UI Transparency & Theme Management\n• Webhook Integration & Config Saver"
                else
                    subPageContentText.Text = "Displaying detailed features under category [" .. title .. "].\n\n- Status: Normal operation\n- Description: " .. desc
                end
                
                subSearchBox.Text = ""
                searchBarCard.Visible = false
                gridMenu.Visible = false
                subPagesContainer.Visible = true
            end)

            table.insert(cardList, {Card = card, Title = string.lower(title), Desc = string.lower(desc)})
        end

        CreateCategoryCard("Shop", "🛒", "Item shop, tools, ect.", 1)
        CreateCategoryCard("Setting farm", "⚙️", "Player settings.", 2)
        CreateCategoryCard("Farm", "⚔️", "Auto farm level, bone,...", 3)
        CreateCategoryCard("Item and Quest", "📦", "Auto quest, item in sea 1.", 4)
        CreateCategoryCard("Teleport Island", "🏝️", "Quick teleport to islands.", 5)
        CreateCategoryCard("Fruit", "🍎", "Auto collection fruit, random, ect.", 6)
        CreateCategoryCard("ESP", "👁️", "ESP player/item/chest.", 7)
        CreateCategoryCard("Setting", "🛠️", "Hub configuration settings.", 8)

        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local query = string.lower(searchBox.Text)
            for _, item in ipairs(cardList) do
                if query == "" or string.find(item.Title, query) or string.find(item.Desc, query) then
                    item.Card.Visible = true
                else
                    item.Card.Visible = false
                end
            end
        end)

        gridMenu.CanvasSize = UDim2.new(0, 0, 0, 360)
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    return tabFrame
end
