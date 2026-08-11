-- Home.lua
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


        local homeLayout = Instance.new("UIListLayout")
        homeLayout.Parent = tabFrame
        homeLayout.SortOrder = Enum.SortOrder.LayoutOrder
        homeLayout.Padding = UDim.new(0, 12)

        local welcomeCard = Instance.new("Frame")
        welcomeCard.Parent = tabFrame
        welcomeCard.Size = UDim2.new(1, 0, 0, 75)
        welcomeCard.BackgroundColor3 = Config.BgCard
        welcomeCard.BackgroundTransparency = 0.15
        welcomeCard.BorderSizePixel = 0
        welcomeCard.LayoutOrder = 1
        Instance.new("UICorner", welcomeCard).CornerRadius = UDim.new(0, 10)
        local welcomeStroke = Instance.new("UIStroke")
        welcomeStroke.Parent = welcomeCard
        welcomeStroke.Color = Config.ThemeColor
        welcomeStroke.Thickness = 1.5
        table.insert(allHubStrokes, welcomeStroke)
        AddHoverGlow(welcomeCard, welcomeStroke)

        local welcomeIcon = Instance.new("TextLabel")
        welcomeIcon.Parent = welcomeCard
        welcomeIcon.Size = UDim2.new(0, 45, 0, 45)
        welcomeIcon.Position = UDim2.new(0, 12, 0.5, -22.5)
        welcomeIcon.BackgroundTransparency = 1
        welcomeIcon.Font = Enum.Font.GothamBold
        welcomeIcon.TextSize = 26
        welcomeIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        welcomeIcon.Text = "🌊"
        welcomeIcon.TextXAlignment = Enum.TextXAlignment.Center

        local welcomeTitle = Instance.new("TextLabel")
        welcomeTitle.Parent = welcomeCard
        welcomeTitle.Size = UDim2.new(1, -70, 0, 22)
        welcomeTitle.Position = UDim2.new(0, 62, 0, 15)
        welcomeTitle.BackgroundTransparency = 1
        welcomeTitle.Font = Enum.Font.GothamBold
        welcomeTitle.TextSize = 15
        welcomeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        welcomeTitle.Text = "Welcome to FishHub!"
        welcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
        welcomeTitle.TextTruncate = Enum.TextTruncate.AtEnd

        local welcomeSub = Instance.new("TextLabel")
        welcomeSub.Parent = welcomeCard
        welcomeSub.Size = UDim2.new(1, -70, 0, 20)
        welcomeSub.Position = UDim2.new(0, 62, 0, 38)
        welcomeSub.BackgroundTransparency = 1
        welcomeSub.Font = Enum.Font.Gotham
        welcomeSub.TextSize = 12
        welcomeSub.TextColor3 = Color3.fromRGB(180, 220, 255)
        welcomeSub.Text = "Ready to experience the ultimate script in " .. gameName .. "!"
        welcomeSub.TextXAlignment = Enum.TextXAlignment.Left
        welcomeSub.TextTruncate = Enum.TextTruncate.AtEnd

        local function CreateSectionDivider(text, order)
            local dividerContainer = Instance.new("Frame")
            dividerContainer.Parent = tabFrame
            dividerContainer.Size = UDim2.new(1, 0, 0, 30)
            dividerContainer.BackgroundTransparency = 1
            dividerContainer.LayoutOrder = order

            local textLbl = Instance.new("TextLabel")
            textLbl.Parent = dividerContainer
            textLbl.Size = UDim2.new(0, 0, 1, 0)
            textLbl.Position = UDim2.new(0.5, 0, 0, 0)
            textLbl.BackgroundTransparency = 1
            textLbl.Font = Enum.Font.GothamBold
            textLbl.TextSize = 12
            textLbl.TextColor3 = Config.ThemeColor
            textLbl.Text = string.upper(text)
            textLbl.AutomaticSize = Enum.AutomaticSize.X
            textLbl.AnchorPoint = Vector2.new(0.5, 0)
            table.insert(allThemeTexts, textLbl)

            local leftLine = Instance.new("Frame")
            leftLine.Parent = dividerContainer
            leftLine.Size = UDim2.new(0.5, -95, 0, 3)
            leftLine.Position = UDim2.new(0, 0, 0.5, -1.5)
            leftLine.BackgroundColor3 = Config.ThemeColor
            leftLine.BorderSizePixel = 0
            Instance.new("UICorner", leftLine).CornerRadius = UDim.new(1, 0)
            table.insert(allHubLines, leftLine)

            local rightLine = Instance.new("Frame")
            rightLine.Parent = dividerContainer
            rightLine.Size = UDim2.new(0.5, -95, 0, 3)
            rightLine.Position = UDim2.new(0.5, 95, 0.5, -1.5)
            rightLine.BackgroundColor3 = Config.ThemeColor
            rightLine.BorderSizePixel = 0
            Instance.new("UICorner", rightLine).CornerRadius = UDim.new(1, 0)
            table.insert(allHubLines, rightLine)
        end

        CreateSectionDivider("player status", 2)

        local statsContainer = Instance.new("Frame")
        statsContainer.Parent = tabFrame
        statsContainer.Size = UDim2.new(1, 0, 0, 130)
        statsContainer.BackgroundTransparency = 1
        statsContainer.LayoutOrder = 3

        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.Parent = statsContainer
        gridLayout.CellSize = UDim2.new(0.5, -5, 0, 56)
        gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
        gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local function CreateStatCard(title, icon)
            local card = Instance.new("Frame")
            card.BackgroundColor3 = Config.BgCard
            card.BackgroundTransparency = 0.2
            card.BorderSizePixel = 0
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
            local stroke = Instance.new("UIStroke")
            stroke.Parent = card
            stroke.Color = Config.ThemeColor
            stroke.Thickness = 1
            table.insert(allHubStrokes, stroke)
            AddHoverGlow(card, stroke)

            local titleLbl = Instance.new("TextLabel")
            titleLbl.Parent = card
            titleLbl.Size = UDim2.new(1, -12, 0, 18)
            titleLbl.Position = UDim2.new(0, 6, 0, 6)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Font = Enum.Font.GothamBold
            titleLbl.TextSize = 11
            titleLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
            titleLbl.Text = icon .. "  " .. title
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left

            local valLbl = Instance.new("TextLabel")
            valLbl.Parent = card
            valLbl.Size = UDim2.new(1, -12, 0, 24)
            valLbl.Position = UDim2.new(0, 6, 0, 24)
            valLbl.BackgroundTransparency = 1
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 14
            valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            valLbl.Text = "Loading..."
            valLbl.TextXAlignment = Enum.TextXAlignment.Left
            valLbl.TextTruncate = Enum.TextTruncate.AtEnd

            return card, titleLbl, valLbl
        end

        local levelCard, _, levelVal = CreateStatCard("LEVEL", "⭐")
        levelCard.Parent = statsContainer
        levelCard.LayoutOrder = 1

        local factionCard, factionTitleLbl, factionVal = CreateStatCard("BOUNTY", "⚔️")
        factionCard.Parent = statsContainer
        factionCard.LayoutOrder = 2

        local fragCard, _, fragVal = CreateStatCard("FRAGMENTS", "💎")
        fragCard.Parent = statsContainer
        fragCard.LayoutOrder = 3

        local beliCard, _, beliVal = CreateStatCard("BELI", "💵") 
        beliCard.Parent = statsContainer
        beliCard.LayoutOrder = 4

        task.spawn(function()
            while tabFrame and tabFrame.Parent do
                pcall(function()
                    local lvl = "N/A"
                    if Player:FindFirstChild("leaderstats") then
                        local ls = Player.leaderstats
                        if ls:FindFirstChild("Level") then lvl = ls.Level.Value
                        elseif ls:FindFirstChild("Lvl") then lvl = ls.Lvl.Value end
                    end
                    if lvl == "N/A" and Player:FindFirstChild("Data") then
                        local data = Player.Data
                        if data:FindFirstChild("Level") then lvl = data.Level.Value
                        elseif data:FindFirstChild("Lvl") then lvl = data.Lvl.Value end
                    end
                    levelVal.Text = tostring(lvl)

                    local beli = "0"
                    if Player:FindFirstChild("leaderstats") then
                        local ls = Player.leaderstats
                        if ls:FindFirstChild("Beli") then beli = ls.Beli.Value
                        elseif ls:FindFirstChild("Money") then beli = ls.Money.Value
                        elseif ls:FindFirstChild("Cash") then beli = ls.Cash.Value end
                    end
                    if beli == "0" and Player:FindFirstChild("Data") then
                        local data = Player.Data
                        if data:FindFirstChild("Beli") then beli = data.Beli.Value
                        elseif data:FindFirstChild("Money") then beli = data.Money.Value
                        elseif data:FindFirstChild("Cash") then beli = data.Cash.Value end
                    end
                    beliVal.Text = tostring(beli)

                    local frag = "0"
                    if Player:FindFirstChild("leaderstats") then
                        local ls = Player.leaderstats
                        if ls:FindFirstChild("Fragments") then frag = ls.Fragments.Value
                        elseif ls:FindFirstChild("Fragment") then frag = ls.Fragment.Value end
                    end
                    if frag == "0" and Player:FindFirstChild("Data") then
                        local data = Player.Data
                        if data:FindFirstChild("Fragments") then frag = data.Fragments.Value
                        elseif data:FindFirstChild("Fragment") then frag = data.Fragment.Value end
                    end
                    fragVal.Text = tostring(frag)

                    local isMarine = false
                    if Player.Team then
                        local teamName = string.lower(Player.Team.Name)
                        if string.find(teamName, "marine") or string.find(teamName, "hải quân") then
                            isMarine = true
                        end
                    end

                    if isMarine then
                        factionTitleLbl.Text = "🛡️  HONOR"
                        local honor = "0"
                        if Player:FindFirstChild("leaderstats") then
                            local ls = Player.leaderstats
                            if ls:FindFirstChild("Honor") then honor = ls.Honor.Value
                            elseif ls:FindFirstChild("Bounty") then honor = ls.Bounty.Value
                            elseif ls:FindFirstChild("Bounty/Honor") then honor = ls["Bounty/Honor"].Value end
                        end
                        if honor == "0" and Player:FindFirstChild("Data") then
                            local data = Player.Data
                            if data:FindFirstChild("Honor") then honor = data.Honor.Value
                            elseif data:FindFirstChild("Bounty") then honor = data.Bounty.Value
                            elseif data:FindFirstChild("Bounty/Honor") then honor = data["Bounty/Honor"].Value end
                        end
                        factionVal.Text = tostring(honor)
                    else
                        factionTitleLbl.Text = "⚔️  BOUNTY"
                        local bounty = "0"
                        if Player:FindFirstChild("leaderstats") then
                            local ls = Player.leaderstats
                            if ls:FindFirstChild("Bounty") then bounty = ls.Bounty.Value
                            elseif ls:FindFirstChild("Honor") then honor = ls.Honor.Value
                            elseif ls:FindFirstChild("Bounty/Honor") then bounty = ls["Bounty/Honor"].Value end
                        end
                        if bounty == "0" and Player:FindFirstChild("Data") then
                            local data = Player.Data
                            if data:FindFirstChild("Bounty") then bounty = data.Bounty.Value
                            elseif data:FindFirstChild("Honor") then honor = data.Honor.Value
                            elseif data:FindFirstChild("Bounty/Honor") then bounty = data["Bounty/Honor"].Value end
                        end
                        factionVal.Text = tostring(bounty)
                    end
                end)
                task.wait(1)
            end
        end)

        CreateSectionDivider("information", 4)

        local profileCard = Instance.new("Frame")
        profileCard.Parent = tabFrame
        profileCard.Size = UDim2.new(1, 0, 0, 215)
        profileCard.BackgroundColor3 = Config.BgCard
        profileCard.BackgroundTransparency = 0.2
        profileCard.BorderSizePixel = 0
        profileCard.LayoutOrder = 5
        Instance.new("UICorner", profileCard).CornerRadius = UDim.new(0, 10)
        local profileStroke = Instance.new("UIStroke")
        profileStroke.Parent = profileCard
        profileStroke.Color = Config.ThemeColor
        profileStroke.Thickness = 1
        table.insert(allHubStrokes, profileStroke)
        AddHoverGlow(profileCard, profileStroke)

        local avtImg = Instance.new("ImageLabel")
        avtImg.Parent = profileCard
        avtImg.Size = UDim2.new(0, 66, 0, 66)
        avtImg.Position = UDim2.new(0, 12, 0, 10)
        avtImg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        avtImg.BorderSizePixel = 0
        avtImg.Image = "rbxassetid://0"
        Instance.new("UICorner", avtImg).CornerRadius = UDim.new(1, 0)
        local avtStroke = Instance.new("UIStroke")
        avtStroke.Parent = avtImg
        avtStroke.Color = Config.ThemeColor
        avtStroke.Thickness = 2
        table.insert(allHubStrokes, avtStroke)

        task.spawn(function()
            pcall(function()
                local content = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                avtImg.Image = content
            end)
        end)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Parent = profileCard
        nameLbl.Size = UDim2.new(1, -95, 0, 20)
        nameLbl.Position = UDim2.new(0, 90, 0, 10)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 14
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.Text = Player.DisplayName
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left

        local tagLbl = Instance.new("TextLabel")
        tagLbl.Parent = profileCard
        tagLbl.Size = UDim2.new(1, -95, 0, 16)
        tagLbl.Position = UDim2.new(0, 90, 0, 30)
        tagLbl.BackgroundTransparency = 1
        tagLbl.Font = Enum.Font.GothamMedium
        tagLbl.TextSize = 11
        tagLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
        tagLbl.Text = "@" .. Player.Name
        tagLbl.TextXAlignment = Enum.TextXAlignment.Left

        local idLbl = Instance.new("TextLabel")
        idLbl.Parent = profileCard
        idLbl.Size = UDim2.new(1, -95, 0, 16)
        idLbl.Position = UDim2.new(0, 90, 0, 48)
        idLbl.BackgroundTransparency = 1
        idLbl.Font = Enum.Font.GothamMedium
        idLbl.TextSize = 11
        idLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
        idLbl.Text = "UserID: " .. tostring(Player.UserId)
        idLbl.TextXAlignment = Enum.TextXAlignment.Left

        local executorLbl = Instance.new("TextLabel")
        executorLbl.Parent = profileCard
        executorLbl.Size = UDim2.new(1, -95, 0, 16)
        executorLbl.Position = UDim2.new(0, 90, 0, 66)
        executorLbl.BackgroundTransparency = 1
        executorLbl.Font = Enum.Font.GothamMedium
        executorLbl.TextSize = 11
        executorLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
        
        local executorName = "Unknown"
        pcall(function()
            if identifyexecutor then
                executorName = identifyexecutor()
            elseif getexecutorname then
                executorName = getexecutorname()
            end
        end)
        executorLbl.Text = "Executor: " .. tostring(executorName)
        executorLbl.TextXAlignment = Enum.TextXAlignment.Left

        local infoDivider = Instance.new("Frame")
        infoDivider.Parent = profileCard
        infoDivider.Size = UDim2.new(1, -20, 0, 1)
        infoDivider.Position = UDim2.new(0, 10, 0, 86)
        infoDivider.BackgroundColor3 = Config.ThemeColor
        infoDivider.BorderSizePixel = 0
        table.insert(allHubLines, infoDivider)

        local function CreateCopyRow(labelText, valToCopy, yPos)
            local lbl = Instance.new("TextLabel")
            lbl.Parent = profileCard
            lbl.Size = UDim2.new(0, 75, 0, 24)
            lbl.Position = UDim2.new(0, 12, 0, yPos)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
            lbl.Text = labelText
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local valBox = Instance.new("TextBox")
            valBox.Parent = profileCard
            valBox.Size = UDim2.new(1, -170, 0, 24)
            valBox.Position = UDim2.new(0, 85, 0, yPos)
            valBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            valBox.BackgroundTransparency = 0.5
            valBox.BorderSizePixel = 0
            valBox.Font = Enum.Font.Code
            valBox.TextSize = 11
            valBox.TextColor3 = Config.ThemeColor
            valBox.Text = tostring(valToCopy)
            valBox.ClearTextOnFocus = false
            valBox.TextEditable = false
            Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 4)
            table.insert(allThemeTexts, valBox)

            local copyBtn = Instance.new("TextButton")
            copyBtn.Parent = profileCard
            copyBtn.Size = UDim2.new(0, 60, 0, 24)
            copyBtn.Position = UDim2.new(1, -72, 0, yPos)
            copyBtn.BackgroundColor3 = Config.ThemeColor
            copyBtn.BorderSizePixel = 0
            copyBtn.AutoButtonColor = false
            copyBtn.Font = Enum.Font.GothamBold
            copyBtn.TextSize = 11
            copyBtn.TextColor3 = Color3.fromRGB(30, 30, 40)
            copyBtn.Text = "COPY"
            Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 4)

            copyBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    if setclipboard then
                        setclipboard(tostring(valToCopy))
                    end
                end)
                ShowNotification("Successfully copied " .. labelText .. "!")
            end)
        end

        CreateCopyRow("PlaceID:", game.PlaceId, 98)
        CreateCopyRow("JobID:", game.JobId, 128)

        local inputLbl = Instance.new("TextLabel")
        inputLbl.Parent = profileCard
        inputLbl.Size = UDim2.new(0, 75, 0, 24)
        inputLbl.Position = UDim2.new(0, 12, 0, 158)
        inputLbl.BackgroundTransparency = 1
        inputLbl.Font = Enum.Font.GothamBold
        inputLbl.TextSize = 11
        inputLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
        inputLbl.Text = "Input Job:"
        inputLbl.TextXAlignment = Enum.TextXAlignment.Left

        local customJobBox = Instance.new("TextBox")
        customJobBox.Parent = profileCard
        customJobBox.Size = UDim2.new(1, -170, 0, 24)
        customJobBox.Position = UDim2.new(0, 85, 0, 158)
        customJobBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        customJobBox.BackgroundTransparency = 0.5
        customJobBox.BorderSizePixel = 0
        customJobBox.Font = Enum.Font.Code
        customJobBox.TextSize = 11
        customJobBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        customJobBox.PlaceholderText = "Paste Job ID here..."
        customJobBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
        customJobBox.Text = ""
        customJobBox.ClearTextOnFocus = false
        Instance.new("UICorner", customJobBox).CornerRadius = UDim.new(0, 4)

        local joinCustomBtn = Instance.new("TextButton")
        joinCustomBtn.Parent = profileCard
        joinCustomBtn.Size = UDim2.new(0, 60, 0, 24)
        joinCustomBtn.Position = UDim2.new(1, -72, 0, 158)
        joinCustomBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
        joinCustomBtn.BorderSizePixel = 0
        joinCustomBtn.AutoButtonColor = false
        joinCustomBtn.Font = Enum.Font.GothamBold
        joinCustomBtn.TextSize = 11
        joinCustomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        joinCustomBtn.Text = "JOIN"
        Instance.new("UICorner", joinCustomBtn).CornerRadius = UDim.new(0, 4)
        
        local joinCustomStroke = Instance.new("UIStroke")
        joinCustomStroke.Parent = joinCustomBtn
        joinCustomStroke.Color = Config.ThemeColor
        joinCustomStroke.Thickness = 1
        table.insert(allHubStrokes, joinCustomStroke)
        AddHoverGlow(joinCustomBtn, joinCustomStroke)

        joinCustomBtn.MouseButton1Click:Connect(function()
            local targetJobId = customJobBox.Text
            if targetJobId and targetJobId ~= "" then
                pcall(function()
                    ShowNotification("Teleporting to custom Job ID...")
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, targetJobId, Player)
                end)
            else
                ShowNotification("Please enter a valid Job ID first!")
            end
        end)

        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 550)

    return tabFrame
end
