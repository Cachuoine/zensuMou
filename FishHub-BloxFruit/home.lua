return function(ctx)
    local Players = game:GetService("Players")
    local MarketplaceService = game:GetService("MarketplaceService")

    local Player = ctx.Player
    local Container = ctx.Container
    local Theme = ctx.ThemeColor()
    local Text = ctx.Config.Text
    local Muted = ctx.Config.Muted
    local Inner = ctx.Config.Inner
    local Border = ctx.Config.Border

    local function Corner(parent, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius or 8)
        c.Parent = parent
        return c
    end

    local function Section(parent, title)
        local holder = Instance.new("Frame")
        holder.Parent = parent
        holder.Size = UDim2.new(1, -12, 0, 34)
        holder.BackgroundTransparency = 1

        local lineLeft = Instance.new("Frame")
        lineLeft.Parent = holder
        lineLeft.Size = UDim2.new(0.5, -68, 0, 1)
        lineLeft.Position = UDim2.new(0, 0, 0.5, 6)
        lineLeft.BorderSizePixel = 0
        lineLeft.BackgroundColor3 = Theme
        lineLeft.BackgroundTransparency = 0.15

        local lineRight = Instance.new("Frame")
        lineRight.Parent = holder
        lineRight.Size = UDim2.new(0.5, -68, 0, 1)
        lineRight.Position = UDim2.new(0.5, 68, 0.5, 6)
        lineRight.BorderSizePixel = 0
        lineRight.BackgroundColor3 = Theme
        lineRight.BackgroundTransparency = 0.15

        local gradientL = Instance.new("UIGradient")
        gradientL.Parent = lineLeft
        gradientL.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(0.5, 0.15),
            NumberSequenceKeypoint.new(1, 0)
        })

        local gradientR = Instance.new("UIGradient")
        gradientR.Parent = lineRight
        gradientR.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.5, 0.15),
            NumberSequenceKeypoint.new(1, 0.85)
        })

        local label = Instance.new("TextLabel")
        label.Parent = holder
        label.Size = UDim2.fromOffset(136, 22)
        label.Position = UDim2.new(0.5, 0, 0.5, 0)
        label.AnchorPoint = Vector2.new(0.5, 0.5)
        label.BackgroundTransparency = 1
        label.Text = title
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextColor3 = Theme

        return holder
    end

    local function Card(height)
        local card = Instance.new("Frame")
        card.Parent = Container
        card.Size = UDim2.new(1, -12, 0, height)
        card.BackgroundColor3 = Inner
        card.BackgroundTransparency = 0.05
        card.BorderSizePixel = 0
        Corner(card, 9)

        local stroke = Instance.new("UIStroke")
        stroke.Parent = card
        stroke.Color = Border
        stroke.Transparency = 0.35

        return card
    end

    local welcome = Card(74)

    local welcomeTitle = Instance.new("TextLabel")
    welcomeTitle.Parent = welcome
    welcomeTitle.Size = UDim2.new(1, -24, 0, 24)
    welcomeTitle.Position = UDim2.fromOffset(12, 10)
    welcomeTitle.BackgroundTransparency = 1
    welcomeTitle.Text = "WELCOME TO FISHHUB"
    welcomeTitle.Font = Enum.Font.GothamBold
    welcomeTitle.TextSize = 14
    welcomeTitle.TextColor3 = Theme
    welcomeTitle.TextXAlignment = Enum.TextXAlignment.Left

    local gameName = "Blox Fruits"
    pcall(function()
        local info = MarketplaceService:GetProductInfo(game.PlaceId)
        if info and info.Name then gameName = info.Name end
    end)

    local welcomeText = Instance.new("TextLabel")
    welcomeText.Parent = welcome
    welcomeText.Size = UDim2.new(1, -24, 0, 26)
    welcomeText.Position = UDim2.fromOffset(12, 36)
    welcomeText.BackgroundTransparency = 1
    welcomeText.Text = "Welcome to FishHub • Supported game: " .. gameName
    welcomeText.Font = Enum.Font.GothamMedium
    welcomeText.TextSize = 10
    welcomeText.TextColor3 = Muted
    welcomeText.TextXAlignment = Enum.TextXAlignment.Left
    welcomeText.TextTruncate = Enum.TextTruncate.AtEnd

    Section(Container, "PLAYER STATUS")

    local statusCard = Card(118)

    local dataFolder = Player:FindFirstChild("Data")
    local function readValue(name, default)
        local source = dataFolder and dataFolder:FindFirstChild(name)
        if source and source.Value ~= nil then
            return source.Value
        end
        return default
    end

    local function teamName()
        if Player.Team then return Player.Team.Name end
        return "Unknown"
    end

    local function makeStat(parent, x, y, title, getter)
        local box = Instance.new("Frame")
        box.Parent = parent
        box.Size = UDim2.new(0.5, -18, 0, 42)
        box.Position = UDim2.new(x, x == 0 and 10 or 8, 0, y)
        box.BackgroundColor3 = ctx.Config.Card
        box.BorderSizePixel = 0
        Corner(box, 7)

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Parent = box
        titleLabel.Size = UDim2.new(1, -12, 0, 15)
        titleLabel.Position = UDim2.fromOffset(8, 4)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.Font = Enum.Font.GothamMedium
        titleLabel.TextSize = 8
        titleLabel.TextColor3 = Muted
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Parent = box
        valueLabel.Size = UDim2.new(1, -12, 0, 18)
        valueLabel.Position = UDim2.fromOffset(8, 19)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 10
        valueLabel.TextColor3 = Text
        valueLabel.TextXAlignment = Enum.TextXAlignment.Left

        local function update()
            local ok, value = pcall(getter)
            valueLabel.Text = ok and tostring(value) or "N/A"
        end

        update()
        task.spawn(function()
            while valueLabel.Parent do
                update()
                task.wait(1)
            end
        end)
    end

    makeStat(statusCard, 0, 8, "LEVEL", function()
        return readValue("Level", 0)
    end)

    makeStat(statusCard, 1, 8, "TEAM", teamName)

    makeStat(statusCard, 0, 58, "BELI", function()
        return readValue("Beli", 0)
    end)

    makeStat(statusCard, 1, 58, "FRAGMENTS", function()
        return readValue("Fragments", 0)
    end)

    Section(Container, "INFORMATION")

    local infoCard = Card(118)

    local avatar = Instance.new("ImageLabel")
    avatar.Parent = infoCard
    avatar.Size = UDim2.fromOffset(70, 70)
    avatar.Position = UDim2.fromOffset(12, 24)
    avatar.BackgroundColor3 = ctx.Config.Card
    avatar.BorderSizePixel = 0
    avatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Corner(avatar, 10)

    task.spawn(function()
        local ok, image = pcall(function()
            return Players:GetUserThumbnailAsync(
                Player.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)
        if ok then avatar.Image = image end
    end)

    local function infoLine(text, y, accent)
        local label = Instance.new("TextLabel")
        label.Parent = infoCard
        label.Size = UDim2.new(1, -100, 0, 18)
        label.Position = UDim2.fromOffset(94, y)
        label.BackgroundTransparency = 1
        label.Text = text
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 9.5
        label.TextColor3 = accent and Theme or Text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd
        return label
    end

    infoLine(Player.DisplayName, 14, true)
    infoLine("@" .. Player.Name, 34, false)
    infoLine("UserId: " .. tostring(Player.UserId), 54, false)

    local executor = "Unknown"
    pcall(function()
        if identifyexecutor then
            local name = identifyexecutor()
            if name and name ~= "" then executor = tostring(name) end
        end
    end)

    infoLine("Executor: " .. executor, 74, false)
end
