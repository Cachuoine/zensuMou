return function(ctx)
    local tabFrame = ctx.TabFrame
    local Config = ctx.Config
    local Players = ctx.Players
    local AddHoverGlow = ctx.AddHoverGlow

    local gearLayout = Instance.new("UIListLayout")
    gearLayout.Parent = tabFrame
    gearLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gearLayout.Padding = UDim.new(0, 15)
    gearLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local paddingFrame = Instance.new("Frame")
    paddingFrame.Parent = tabFrame
    paddingFrame.Size = UDim2.new(1, 0, 0, 40)
    paddingFrame.BackgroundTransparency = 1
    paddingFrame.LayoutOrder = 1

    local avtCard = Instance.new("Frame")
    avtCard.Parent = tabFrame
    avtCard.Size = UDim2.new(0, 110, 0, 110)
    avtCard.BackgroundColor3 = Config.BgCard
    avtCard.BackgroundTransparency = 0.2
    avtCard.BorderSizePixel = 0
    avtCard.LayoutOrder = 2
    Instance.new("UICorner", avtCard).CornerRadius = UDim.new(1, 0)

    local avtCardStroke = Instance.new("UIStroke")
    avtCardStroke.Parent = avtCard
    avtCardStroke.Color = Config.ThemeColor
    avtCardStroke.Thickness = 2
    ctx.RegisterStroke(avtCardStroke)
    AddHoverGlow(avtCard, avtCardStroke)

    local fixedAvtImg = Instance.new("ImageLabel")
    fixedAvtImg.Parent = avtCard
    fixedAvtImg.Size = UDim2.new(1, -10, 1, -10)
    fixedAvtImg.Position = UDim2.new(0, 5, 0, 5)
    fixedAvtImg.BackgroundTransparency = 1
    fixedAvtImg.Image = "rbxassetid://0"
    Instance.new("UICorner", fixedAvtImg).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        pcall(function()
            local targetUserId = Players:GetUserIdFromNameAsync("thankhuyenhuy")
            if targetUserId then
                local content = Players:GetUserThumbnailAsync(targetUserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                fixedAvtImg.Image = content
            end
        end)
    end)

    local infoCard = Instance.new("Frame")
    infoCard.Parent = tabFrame
    infoCard.Size = UDim2.new(0.9, 0, 0, 80)
    infoCard.BackgroundColor3 = Config.BgCard
    infoCard.BackgroundTransparency = 0.2
    infoCard.BorderSizePixel = 0
    infoCard.LayoutOrder = 3
    Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 12)

    local infoStroke = Instance.new("UIStroke")
    infoStroke.Parent = infoCard
    infoStroke.Color = Config.ThemeColor
    infoStroke.Thickness = 1.5
    ctx.RegisterStroke(infoStroke)
    AddHoverGlow(infoCard, infoStroke)

    local scriptTitleLbl = Instance.new("TextLabel")
    scriptTitleLbl.Parent = infoCard
    scriptTitleLbl.Size = UDim2.new(1, 0, 0, 25)
    scriptTitleLbl.Position = UDim2.new(0, 0, 0, 15)
    scriptTitleLbl.BackgroundTransparency = 1
    scriptTitleLbl.Font = Enum.Font.GothamBold
    scriptTitleLbl.TextSize = 16
    scriptTitleLbl.TextColor3 = Config.ThemeColor
    scriptTitleLbl.Text = "FishHub Gear"
    scriptTitleLbl.TextXAlignment = Enum.TextXAlignment.Center
    ctx.RegisterThemeText(scriptTitleLbl)

    local scriptAuthorLbl = Instance.new("TextLabel")
    scriptAuthorLbl.Parent = infoCard
    scriptAuthorLbl.Size = UDim2.new(1, 0, 0, 25)
    scriptAuthorLbl.Position = UDim2.new(0, 0, 0, 40)
    scriptAuthorLbl.BackgroundTransparency = 1
    scriptAuthorLbl.Font = Enum.Font.GothamMedium
    scriptAuthorLbl.TextSize = 14
    scriptAuthorLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    scriptAuthorLbl.Text = "Script Made by: DaoHuyLam"
    scriptAuthorLbl.TextXAlignment = Enum.TextXAlignment.Center

    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 320)
end
