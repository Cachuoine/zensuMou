return function(ctx)
    local tabFrame = ctx.TabFrame
    local Config = ctx.Config
    local AddHoverGlow = ctx.AddHoverGlow

    local homeLayout = Instance.new("UIListLayout")
    homeLayout.Parent = tabFrame
    homeLayout.SortOrder = Enum.SortOrder.LayoutOrder
    homeLayout.Padding = UDim.new(0, 12)

    local welcomeCard = Instance.new("Frame")
    welcomeCard.Name = "WelcomeCard"
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
    ctx.RegisterStroke(welcomeStroke)
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
    welcomeSub.Text = "Ready to experience the ultimate script in " .. ctx.GameName .. "!"
    welcomeSub.TextXAlignment = Enum.TextXAlignment.Left
    welcomeSub.TextTruncate = Enum.TextTruncate.AtEnd

    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 87)
end
