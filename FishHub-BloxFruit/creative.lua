return function(ctx)
    local Players = game:GetService("Players")

    local Container = ctx.Container
    local Theme = ctx.ThemeColor()
    local Text = ctx.Config.Text
    local Muted = ctx.Config.Muted
    local Inner = ctx.Config.Inner
    local Card = ctx.Config.Card
    local Border = ctx.Config.Border

    local function Corner(parent, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius or 8)
        c.Parent = parent
    end

    local function Section(title)
        local holder = Instance.new("Frame")
        holder.Parent = Container
        holder.Size = UDim2.new(1, -12, 0, 34)
        holder.BackgroundTransparency = 1

        local left = Instance.new("Frame")
        left.Parent = holder
        left.Size = UDim2.new(0.5, -68, 0, 1)
        left.Position = UDim2.new(0, 0, 0.5, 6)
        left.BackgroundColor3 = Theme
        left.BorderSizePixel = 0

        local right = Instance.new("Frame")
        right.Parent = holder
        right.Size = UDim2.new(0.5, -68, 0, 1)
        right.Position = UDim2.new(0.5, 68, 0, 6)
        right.BackgroundColor3 = Theme
        right.BorderSizePixel = 0

        local gl = Instance.new("UIGradient")
        gl.Parent = left
        gl.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(0.6, 0.1),
            NumberSequenceKeypoint.new(1, 0)
        })

        local gr = Instance.new("UIGradient")
        gr.Parent = right
        gr.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.4, 0.1),
            NumberSequenceKeypoint.new(1, 0.9)
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
    end

    local function CardFrame(height)
        local card = Instance.new("Frame")
        card.Parent = Container
        card.Size = UDim2.new(1, -12, 0, height)
        card.BackgroundColor3 = Inner
        card.BorderSizePixel = 0
        Corner(card, 9)

        local stroke = Instance.new("UIStroke")
        stroke.Parent = card
        stroke.Color = Border
        stroke.Transparency = 0.35

        return card
    end

    Section("ROBLOX PLAYERS")

    local robloxCard = CardFrame(108)

    local avatar = Instance.new("ImageLabel")
    avatar.Parent = robloxCard
    avatar.Size = UDim2.fromOffset(64, 64)
    avatar.Position = UDim2.fromOffset(12, 22)
    avatar.BackgroundColor3 = Card
    avatar.BorderSizePixel = 0
    avatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Corner(avatar, 10)

    task.spawn(function()
        local ok, image = pcall(function()
            return Players:GetUserThumbnailAsync(
                ctx.Player.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)
        if ok then avatar.Image = image end
    end)

    local title = Instance.new("TextLabel")
    title.Parent = robloxCard
    title.Size = UDim2.new(1, -95, 0, 20)
    title.Position = UDim2.fromOffset(88, 24)
    title.BackgroundTransparency = 1
    title.Text = "thankhuyenhuy"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextColor3 = Theme
    title.TextXAlignment = Enum.TextXAlignment.Left

    local username = Instance.new("TextLabel")
    username.Parent = robloxCard
    username.Size = UDim2.new(1, -95, 0, 20)
    username.Position = UDim2.fromOffset(88, 48)
    username.BackgroundTransparency = 1
    username.Text = "@thankhuyenhuy"
    username.Font = Enum.Font.GothamMedium
    username.TextSize = 10
    username.TextColor3 = Muted
    username.TextXAlignment = Enum.TextXAlignment.Left

    Section("FACEBOOK PLAYERS")

    local facebookCard = CardFrame(72)

    local addButton = Instance.new("TextButton")
    addButton.Parent = facebookCard
    addButton.Size = UDim2.new(1, -20, 0, 42)
    addButton.Position = UDim2.fromOffset(10, 15)
    addButton.BackgroundColor3 = Theme
    addButton.BorderSizePixel = 0
    addButton.AutoButtonColor = false
    addButton.Text = "ADD"
    addButton.Font = Enum.Font.GothamBold
    addButton.TextSize = 11
    addButton.TextColor3 = Color3.fromRGB(20, 22, 28)
    Corner(addButton, 8)

    addButton.MouseButton1Click:Connect(function()
        local url = "https://www.facebook.com/dao.huy.lam.09/"
        pcall(function()
            if setclipboard then
                setclipboard(url)
            end
        end)
        ctx.Notify("Facebook link copied")
    end)

    addButton.MouseEnter:Connect(function()
        addButton.BackgroundTransparency = 0.08
    end)

    addButton.MouseLeave:Connect(function()
        addButton.BackgroundTransparency = 0
    end)
end
