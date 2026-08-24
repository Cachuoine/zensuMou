return function(ctx)
    assert(type(ctx) == "table", "FishHub gear.lua: context table is required")

    local Players = ctx.Players
    local UserInputService = ctx.UserInputService
    local TweenService = ctx.TweenService

    local gui = ctx.gui
    local main = ctx.main
    local mainScale = ctx.mainScale
    local Config = ctx.Config

    local allHubStrokes = ctx.allHubStrokes
    local allHubLines = ctx.allHubLines
    local allThemeTexts = ctx.allThemeTexts

    local mainStroke = ctx.mainStroke
    local glowBorder = ctx.glowBorder
    local openStroke = ctx.openStroke
    local openGlow = ctx.openGlow
    local openAccent = ctx.openAccent
    local openStatus = ctx.openStatus
    local openIcon = ctx.openIcon
    local lineStroke = ctx.lineStroke

    local contentHoverRegistry = ctx.contentHoverRegistry
    local tabButtons = ctx.tabButtons
    local CONTENT_BORDER_COLOR = ctx.CONTENT_BORDER_COLOR
    local getActiveTabName = ctx.getActiveTabName

    local loadingScreen = ctx.loadingScreen
    local progressFill = ctx.progressFill
    local loadingStatus = ctx.loadingStatus
    local THEME_LOADING_APPLY_DELAY = ctx.THEME_LOADING_APPLY_DELAY

    local PlayAdvancedThemeLoading = ctx.PlayAdvancedThemeLoading
    local StopLoadingAnimation = ctx.StopLoadingAnimation
    local RestoreUIAfterThemeLoading = ctx.RestoreUIAfterThemeLoading
    local FinishAdvancedThemeLoading = ctx.FinishAdvancedThemeLoading
    local UpdateLoadingTheme = ctx.UpdateLoadingTheme
    local ShowNotification = ctx.ShowNotification

    local isThemeLoading = ctx.isThemeLoading
    local getLoadingAnimationToken = ctx.getLoadingAnimationToken
    local setThemeLoading = ctx.setThemeLoading

    local debugSidebarFrame = ctx.debugSidebarFrame
    local keyStatusSidebarFrame = ctx.keyStatusSidebarFrame
    local debugDividerBetween = ctx.debugDividerBetween

    local gearBtn = ctx.gearBtn

    assert(gui, "FishHub gear.lua: missing gui")
    assert(main, "FishHub gear.lua: missing main")
    assert(mainScale, "FishHub gear.lua: missing mainScale")
    assert(Config, "FishHub gear.lua: missing Config")
    assert(gearBtn, "FishHub gear.lua: Main did not provide Gear button")

    ------------------------------------------------------------------------
    -- STATE
    ------------------------------------------------------------------------

    local isRainbowRunning = false
    local rainbowTransitionActive = false
    local rainbowTransitionSerial = 0

    local staticThemeColor = Config.ThemeColor
    local rainbowHue = select(1, Config.ThemeColor:ToHSV())

    local selectedThemeColor = Config.ThemeColor
    local pickerHue, pickerSaturation, pickerValue = Config.ThemeColor:ToHSV()

    local pickerDragging = nil
    local rainbowSpeedDragging = false
    local listeningKey = false
    local destroyed = false

    ------------------------------------------------------------------------
    -- STYLE HELPERS
    ------------------------------------------------------------------------

    local function safeInsert(list, object)
        if type(list) == "table" and object then
            table.insert(list, object)
        end
    end

    local function corner(parent, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius or 8)
        c.Parent = parent
        return c
    end

    local function stroke(parent, color, thickness, transparency)
        local s = Instance.new("UIStroke")
        s.Color = color or Config.ThemeColor
        s.Thickness = thickness or 1
        s.Transparency = transparency or 0
        s.Parent = parent
        safeInsert(allHubStrokes, s)
        return s
    end

    local function gradient(parent, colorA, colorB, rotation)
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new(colorA, colorB)
        g.Rotation = rotation or 0
        g.Parent = parent
        return g
    end

    local function createShadow(parent)
        local shadow = Instance.new("Frame")
        shadow.Name = "SoftShadow"
        shadow.Parent = parent
        shadow.Size = UDim2.new(1, 8, 1, 8)
        shadow.Position = UDim2.new(0, 0, 0, 4)
        shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shadow.BackgroundTransparency = 0.72
        shadow.BorderSizePixel = 0
        shadow.ZIndex = math.max(0, parent.ZIndex - 1)
        corner(shadow, 12)
        return shadow
    end

    local function addHover(card, cardStroke, accent)
        if not card or not cardStroke then
            return
        end

        local originalColor = card.BackgroundColor3
        local hoverColor = accent or Color3.fromRGB(25, 28, 39)

        card.Active = true
        card.MouseEnter:Connect(function()
            if destroyed then return end
            TweenService:Create(
                card,
                TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {BackgroundColor3 = hoverColor}
            ):Play()

            TweenService:Create(
                cardStroke,
                TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Thickness = 1.8, Transparency = 0}
            ):Play()
        end)

        card.MouseLeave:Connect(function()
            if destroyed then return end
            TweenService:Create(
                card,
                TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {BackgroundColor3 = originalColor}
            ):Play()

            TweenService:Create(
                cardStroke,
                TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Thickness = 1, Transparency = 0.18}
            ):Play()
        end)
    end

    local function createCard(parent, height, order)
        local card = Instance.new("Frame")
        card.Parent = parent
        card.Size = UDim2.new(1, -10, 0, height)
        card.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
        card.BackgroundTransparency = 0.08
        card.BorderSizePixel = 0
        card.LayoutOrder = order or 1
        card.ZIndex = 2
        corner(card, 10)

        local s = stroke(card, Config.ThemeColor, 1, 0.18)
        createShadow(card)

        local accent = Instance.new("Frame")
        accent.Name = "AccentBar"
        accent.Parent = card
        accent.Size = UDim2.new(0, 3, 1, -18)
        accent.Position = UDim2.new(0, 7, 0, 9)
        accent.BackgroundColor3 = Config.ThemeColor
        accent.BorderSizePixel = 0
        accent.ZIndex = 3
        corner(accent, 3)

        gradient(card, Color3.fromRGB(27, 30, 42), Color3.fromRGB(18, 20, 29), 90)
        addHover(card, s, Color3.fromRGB(29, 32, 45))

        return card, s, accent
    end

    local function createLabel(parent, text, size, position, font, textSize)
        local label = Instance.new("TextLabel")
        label.Parent = parent
        label.Size = size
        label.Position = position
        label.BackgroundTransparency = 1
        label.Font = font or Enum.Font.GothamBold
        label.TextSize = textSize or 11
        label.TextColor3 = Color3.fromRGB(205, 208, 222)
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 4
        return label
    end

    ------------------------------------------------------------------------
    -- SETTINGS WINDOW
    ------------------------------------------------------------------------

    local settingsWindow = Instance.new("Frame")
    settingsWindow.Name = "SettingsWindow"
    settingsWindow.Parent = gui
    settingsWindow.Size = UDim2.new(0, 258, 0, Config.MainHeight)
    settingsWindow.AnchorPoint = Vector2.new(0, 0.5)
    settingsWindow.BackgroundColor3 = Config.BgMain
    settingsWindow.BackgroundTransparency = Config.UITransparency
    settingsWindow.BorderSizePixel = 0
    settingsWindow.Visible = false
    settingsWindow.ZIndex = 200

    local settingsScale = Instance.new("UIScale")
    settingsScale.Parent = settingsWindow
    settingsScale.Scale = 1

    corner(settingsWindow, 15)
    local settingsStroke = stroke(settingsWindow, Config.ThemeColor, 2, 0)

    local settingsGlow = Instance.new("UIStroke")
    settingsGlow.Name = "SettingsGlow"
    settingsGlow.Parent = settingsWindow
    settingsGlow.Color = Config.ThemeColor
    settingsGlow.Thickness = 5
    settingsGlow.Transparency = 0.7

    task.spawn(function()
        while gui and gui.Parent and settingsWindow and settingsWindow.Parent do
            if settingsWindow.Visible then
                TweenService:Create(
                    settingsGlow,
                    TweenInfo.new(1.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {Transparency = 0.45}
                ):Play()
                task.wait(1.15)
                TweenService:Create(
                    settingsGlow,
                    TweenInfo.new(1.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {Transparency = 0.78}
                ):Play()
                task.wait(1.15)
            else
                task.wait(0.25)
            end
        end
    end)

    local settingsTitle = Instance.new("TextLabel")
    settingsTitle.Parent = settingsWindow
    settingsTitle.Size = UDim2.new(1, -40, 0, 32)
    settingsTitle.Position = UDim2.new(0.5, 0, 0, 7)
    settingsTitle.AnchorPoint = Vector2.new(0.5, 0)
    settingsTitle.BackgroundTransparency = 1
    settingsTitle.RichText = true
    settingsTitle.Text = "⚙  <font color='#00E5FF'>SETTING</font>"
    settingsTitle.Font = Enum.Font.GothamBold
    settingsTitle.TextSize = 15
    settingsTitle.TextColor3 = Color3.fromRGB(245, 247, 255)
    settingsTitle.TextXAlignment = Enum.TextXAlignment.Center
    settingsTitle.ZIndex = 205
    safeInsert(allThemeTexts, settingsTitle)

    local titleSub = Instance.new("TextLabel")
    titleSub.Parent = settingsWindow
    titleSub.Size = UDim2.new(1, -30, 0, 15)
    titleSub.Position = UDim2.new(0.5, 0, 0, 29)
    titleSub.AnchorPoint = Vector2.new(0.5, 0)
    titleSub.BackgroundTransparency = 1
    titleSub.Font = Enum.Font.Code
    titleSub.TextSize = 8
    titleSub.TextColor3 = Color3.fromRGB(120, 125, 142)
    titleSub.Text = "FISHHUB  /  CONTROL CENTER"
    titleSub.TextXAlignment = Enum.TextXAlignment.Center
    titleSub.ZIndex = 205

    local settingsLine = Instance.new("Frame")
    settingsLine.Parent = settingsWindow
    settingsLine.Size = UDim2.new(1, -20, 0, 1)
    settingsLine.Position = UDim2.new(0, 10, 0, 45)
    settingsLine.BackgroundColor3 = Config.ThemeColor
    settingsLine.BorderSizePixel = 0
    settingsLine.ZIndex = 205
    safeInsert(allHubLines, settingsLine)

    local settingsLineGradient = Instance.new("UIGradient")
    settingsLineGradient.Parent = settingsLine
    settingsLineGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.95),
        NumberSequenceKeypoint.new(0.18, 0.45),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.82, 0.45),
        NumberSequenceKeypoint.new(1, 0.95),
    })

    local settingsScroll = Instance.new("ScrollingFrame")
    settingsScroll.Name = "SettingsScroll"
    settingsScroll.Parent = settingsWindow
    settingsScroll.Size = UDim2.new(1, -10, 1, -55)
    settingsScroll.Position = UDim2.new(0, 5, 0, 50)
    settingsScroll.BackgroundTransparency = 1
    settingsScroll.BorderSizePixel = 0
    settingsScroll.ScrollBarThickness = 0
    settingsScroll.ScrollBarImageTransparency = 1
    settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    settingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    settingsScroll.ZIndex = 201

    local settingsPadding = Instance.new("UIPadding")
    settingsPadding.Parent = settingsScroll
    settingsPadding.PaddingTop = UDim.new(0, 3)
    settingsPadding.PaddingBottom = UDim.new(0, 10)
    settingsPadding.PaddingLeft = UDim.new(0, 0)
    settingsPadding.PaddingRight = UDim.new(0, 0)

    local settingsLayout = Instance.new("UIListLayout")
    settingsLayout.Parent = settingsScroll
    settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    settingsLayout.Padding = UDim.new(0, 8)
    settingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    ------------------------------------------------------------------------
    -- SECTION DIVIDER
    ------------------------------------------------------------------------

    local function CreateSectionDivider(title, order)
        local container = Instance.new("Frame")
        container.Parent = settingsScroll
        container.Size = UDim2.new(1, -10, 0, 27)
        container.BackgroundTransparency = 1
        container.LayoutOrder = order
        container.ZIndex = 202

        local label = Instance.new("TextLabel")
        label.Parent = container
        label.Size = UDim2.new(1, 0, 0, 16)
        label.Position = UDim2.new(0.5, 0, 0, 0)
        label.AnchorPoint = Vector2.new(0.5, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextColor3 = Config.ThemeColor
        label.Text = title
        label.AutomaticSize = Enum.AutomaticSize.X
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 203
        safeInsert(allThemeTexts, label)

        local leftLine = Instance.new("Frame")
        leftLine.Parent = container
        leftLine.Size = UDim2.new(0.38, -8, 0, 1)
        leftLine.Position = UDim2.new(0, 0, 0, 18)
        leftLine.BackgroundColor3 = Config.ThemeColor
        leftLine.BorderSizePixel = 0
        leftLine.ZIndex = 202
        safeInsert(allHubLines, leftLine)

        local rightLine = Instance.new("Frame")
        rightLine.Parent = container
        rightLine.Size = UDim2.new(0.38, -8, 0, 1)
        rightLine.Position = UDim2.new(0.62, 8, 0, 18)
        rightLine.BackgroundColor3 = Config.ThemeColor
        rightLine.BorderSizePixel = 0
        rightLine.ZIndex = 202
        safeInsert(allHubLines, rightLine)

        return container
    end

    ------------------------------------------------------------------------
    -- THEME PICKER
    ------------------------------------------------------------------------

    CreateSectionDivider("THEME", 1)

    local colorPalette = Instance.new("Frame")
    colorPalette.Name = "ColorPalette"
    colorPalette.Parent = settingsScroll
    colorPalette.Size = UDim2.new(1, -10, 0, 181)
    colorPalette.BackgroundColor3 = Color3.fromRGB(17, 19, 27)
    colorPalette.BackgroundTransparency = 0
    colorPalette.BorderSizePixel = 0
    colorPalette.LayoutOrder = 2
    colorPalette.ZIndex = 202
    corner(colorPalette, 11)

    local paletteStroke = stroke(colorPalette, Config.ThemeColor, 1, 0.12)
    gradient(colorPalette, Color3.fromRGB(24, 27, 39), Color3.fromRGB(14, 16, 23), 90)

    -- THEME COLOR header: restored to the original visible top row.
    local paletteTitle = createLabel(
        colorPalette,
        "THEME COLOR",
        UDim2.new(0, 125, 0, 20),
        UDim2.new(0, 12, 0, 6),
        Enum.Font.GothamBold,
        11
    )
    paletteTitle.TextColor3 = Color3.fromRGB(220, 223, 235)
    paletteTitle.ZIndex = 210

    local paletteValue = Instance.new("TextLabel")
    paletteValue.Parent = colorPalette
    paletteValue.Size = UDim2.new(0, 72, 0, 18)
    paletteValue.Position = UDim2.new(1, -108, 0, 7)
    paletteValue.ZIndex = 210
    paletteValue.BackgroundTransparency = 1
    paletteValue.TextColor3 = Color3.fromRGB(145, 150, 166)
    paletteValue.Font = Enum.Font.Code
    paletteValue.TextSize = 9
    paletteValue.TextXAlignment = Enum.TextXAlignment.Right
    paletteValue.ZIndex = 204

    local palettePreview = Instance.new("Frame")
    palettePreview.Parent = colorPalette
    palettePreview.Size = UDim2.new(0, 25, 0, 18)
    palettePreview.Position = UDim2.new(1, -31, 0, 7)
    palettePreview.ZIndex = 210
    palettePreview.BackgroundColor3 = Config.ThemeColor
    palettePreview.BorderSizePixel = 0
    palettePreview.ZIndex = 204
    corner(palettePreview, 5)

    local previewStroke = stroke(palettePreview, Color3.new(1,1,1), 1, 0.65)

    local svArea = Instance.new("Frame")
    svArea.Name = "SVArea"
    svArea.Parent = colorPalette
    svArea.Size = UDim2.new(1, -58, 0, 118)
    svArea.Position = UDim2.new(0, 10, 0, 35)
    svArea.BackgroundColor3 = Color3.fromHSV(pickerHue, 1, 1)
    svArea.BorderSizePixel = 0
    svArea.ClipsDescendants = true
    svArea.ZIndex = 203
    corner(svArea, 8)

    local svWhite = Instance.new("Frame")
    svWhite.Parent = svArea
    svWhite.Size = UDim2.fromScale(1, 1)
    svWhite.BackgroundColor3 = Color3.new(1,1,1)
    svWhite.BorderSizePixel = 0
    svWhite.ZIndex = 203

    local whiteGradient = Instance.new("UIGradient")
    whiteGradient.Parent = svWhite
    whiteGradient.Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1))
    whiteGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })

    local svBlack = Instance.new("Frame")
    svBlack.Parent = svArea
    svBlack.Size = UDim2.fromScale(1, 1)
    svBlack.BackgroundColor3 = Color3.new(0,0,0)
    svBlack.BorderSizePixel = 0
    svBlack.ZIndex = 204

    local blackGradient = Instance.new("UIGradient")
    blackGradient.Parent = svBlack
    blackGradient.Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0))
    blackGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0)
    })
    blackGradient.Rotation = 90

    local svButton = Instance.new("TextButton")
    svButton.Parent = svArea
    svButton.Size = UDim2.fromScale(1, 1)
    svButton.BackgroundTransparency = 1
    svButton.Text = ""
    svButton.AutoButtonColor = false
    svButton.ZIndex = 206

    local svCursor = Instance.new("Frame")
    svCursor.Parent = svArea
    svCursor.Size = UDim2.new(0, 13, 0, 13)
    svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    svCursor.BackgroundColor3 = Color3.new(1,1,1)
    svCursor.BorderSizePixel = 0
    svCursor.ZIndex = 207
    corner(svCursor, 99)
    stroke(svCursor, Color3.new(0,0,0), 2, 0.1)

    local hueBar = Instance.new("Frame")
    hueBar.Name = "HueBar"
    hueBar.Parent = colorPalette
    hueBar.Size = UDim2.new(0, 18, 0, 118)
    hueBar.Position = UDim2.new(1, -32, 0, 35)
    hueBar.BackgroundColor3 = Color3.new(1,1,1)
    hueBar.BorderSizePixel = 0
    hueBar.ZIndex = 204
    corner(hueBar, 99)

    local hueGradient = Instance.new("UIGradient")
    hueGradient.Parent = hueBar
    hueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.1667, Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.3333, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.6667, Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(0.8333, Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
    })
    hueGradient.Rotation = 90

    local hueButton = Instance.new("TextButton")
    hueButton.Parent = hueBar
    hueButton.Size = UDim2.fromScale(1, 1)
    hueButton.BackgroundTransparency = 1
    hueButton.Text = ""
    hueButton.AutoButtonColor = false
    hueButton.ZIndex = 206

    local hueCursor = Instance.new("Frame")
    hueCursor.Parent = hueBar
    hueCursor.Size = UDim2.new(1, 0, 0, 4)
    hueCursor.AnchorPoint = Vector2.new(0, 0.5)
    hueCursor.BackgroundColor3 = Color3.new(1,1,1)
    hueCursor.BorderSizePixel = 0
    hueCursor.ZIndex = 207
    stroke(hueCursor, Color3.new(0,0,0), 1, 0.15)

    local pickerLocked = false

    local function RefreshPickerLock()
        pickerLocked = isRainbowRunning == true
        svButton.Active = not pickerLocked
        hueButton.Active = not pickerLocked
    end

    local function UpdateThemePicker()
        local hueColor = Color3.fromHSV(pickerHue, 1, 1)
        svArea.BackgroundColor3 = hueColor

        svCursor.Position = UDim2.new(
            pickerSaturation,
            0,
            1 - pickerValue,
            0
        )

        hueCursor.Position = UDim2.new(0, 0, pickerHue, 0)
        selectedThemeColor = Color3.fromHSV(
            pickerHue,
            pickerSaturation,
            pickerValue
        )

        palettePreview.BackgroundColor3 = selectedThemeColor
        previewStroke.Color = Color3.new(1,1,1)

        local r = selectedThemeColor.R * 255
        local g = selectedThemeColor.G * 255
        local b = selectedThemeColor.B * 255

        paletteValue.Text = string.format(
            "#%02X%02X%02X",
            math.floor(r + 0.5),
            math.floor(g + 0.5),
            math.floor(b + 0.5)
        )
    end

    local function GetMousePosition()
        local player = Players.LocalPlayer
        if not player then
            return Vector2.zero
        end
        local mouse = player:GetMouse()
        return Vector2.new(mouse.X, mouse.Y)
    end

    local function UpdateSVFromPosition(pos)
        local abs = svButton.AbsolutePosition
        local size = svButton.AbsoluteSize
        if size.X <= 0 or size.Y <= 0 then return end

        pickerSaturation = math.clamp(
            (pos.X - abs.X) / size.X,
            0,
            1
        )

        pickerValue = math.clamp(
            1 - ((pos.Y - abs.Y) / size.Y),
            0,
            1
        )

        UpdateThemePicker()
    end

    local function UpdateHueFromPosition(pos)
        local abs = hueButton.AbsolutePosition
        local size = hueButton.AbsoluteSize
        if size.Y <= 0 then return end

        pickerHue = math.clamp(
            (pos.Y - abs.Y) / size.Y,
            0,
            1
        )

        UpdateThemePicker()
    end

    local ApplyGlobalTheme

    local function IsPickerLocked()
        return pickerLocked == true
    end

    svButton.MouseButton1Down:Connect(function()
        if IsPickerLocked() then return end
        pickerDragging = "SV"
        UpdateSVFromPosition(GetMousePosition())
    end)

    hueButton.MouseButton1Down:Connect(function()
        if IsPickerLocked() then return end
        pickerDragging = "HUE"
        UpdateHueFromPosition(GetMousePosition())
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end

        if not pickerDragging then
            return
        end

        if IsPickerLocked() then
            pickerDragging = nil
            return
        end

        local pos = GetMousePosition()

        if pickerDragging == "SV" then
            UpdateSVFromPosition(pos)
        else
            UpdateHueFromPosition(pos)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            pickerDragging = nil
        end
    end)

    UpdateThemePicker()

    ------------------------------------------------------------------------
    -- APPLY THEME BUTTON
    ------------------------------------------------------------------------

    local applyThemeBtn = Instance.new("TextButton")
    applyThemeBtn.Parent = settingsScroll
    applyThemeBtn.Size = UDim2.new(1, -10, 0, 34)
    applyThemeBtn.BackgroundColor3 = Config.ThemeColor
    applyThemeBtn.BorderSizePixel = 0
    applyThemeBtn.AutoButtonColor = false
    applyThemeBtn.Font = Enum.Font.GothamBold
    applyThemeBtn.TextSize = 11
    applyThemeBtn.TextColor3 = Color3.fromRGB(18, 20, 28)
    applyThemeBtn.Text = "✓  APPLY THEME"
    applyThemeBtn.LayoutOrder = 3
    applyThemeBtn.ZIndex = 203
    corner(applyThemeBtn, 8)

    local applyStroke = stroke(applyThemeBtn, Config.ThemeColor, 1, 0.1)

    applyThemeBtn.MouseEnter:Connect(function()
        TweenService:Create(
            applyThemeBtn,
            TweenInfo.new(0.18, Enum.EasingStyle.Quint),
            {Size = UDim2.new(1, -4, 0, 36)}
        ):Play()
    end)

    applyThemeBtn.MouseLeave:Connect(function()
        TweenService:Create(
            applyThemeBtn,
            TweenInfo.new(0.18, Enum.EasingStyle.Quint),
            {Size = UDim2.new(1, -10, 0, 34)}
        ):Play()
    end)

    ------------------------------------------------------------------------
    -- RAINBOW TOGGLE
    ------------------------------------------------------------------------

    local rainbowToggleCard, rainbowToggleStrokeCard = createCard(
        settingsScroll,
        44,
        4
    )

    local rainbowToggleLbl = createLabel(
        rainbowToggleCard,
        "Rainbow Continuous",
        UDim2.new(1, -70, 1, 0),
        UDim2.new(0, 16, 0, 0),
        Enum.Font.GothamBold,
        11
    )

    local rainbowSub = createLabel(
        rainbowToggleCard,
        "ANIMATED ACCENT",
        UDim2.new(0, 100, 0, 12),
        UDim2.new(0, 16, 1, -15),
        Enum.Font.Code,
        7
    )
    rainbowSub.TextColor3 = Color3.fromRGB(110, 115, 132)

    local rainbowToggleBox = Instance.new("Frame")
    rainbowToggleBox.Parent = rainbowToggleCard
    rainbowToggleBox.Size = UDim2.new(0, 36, 0, 19)
    rainbowToggleBox.Position = UDim2.new(1, -48, 0.5, -9)
    rainbowToggleBox.BackgroundColor3 = Color3.fromRGB(13, 15, 22)
    rainbowToggleBox.BorderSizePixel = 0
    rainbowToggleBox.ZIndex = 205
    corner(rainbowToggleBox, 99)

    local rainbowToggleStroke = stroke(
        rainbowToggleBox,
        Config.ThemeColor,
        1.5,
        0.1
    )

    local rainbowToggleCircle = Instance.new("Frame")
    rainbowToggleCircle.Parent = rainbowToggleBox
    rainbowToggleCircle.Size = UDim2.new(0, 11, 0, 11)
    rainbowToggleCircle.Position = UDim2.new(0, 5, 0.5, 0)
    rainbowToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
    rainbowToggleCircle.BackgroundColor3 = Config.ThemeColor
    rainbowToggleCircle.BorderSizePixel = 0
    rainbowToggleCircle.ZIndex = 206
    corner(rainbowToggleCircle, 99)

    local rainbowClickArea = Instance.new("TextButton")
    rainbowClickArea.Parent = rainbowToggleCard
    rainbowClickArea.Size = UDim2.fromScale(1,1)
    rainbowClickArea.BackgroundTransparency = 1
    rainbowClickArea.Text = ""
    rainbowClickArea.AutoButtonColor = false
    rainbowClickArea.ZIndex = 210

    ------------------------------------------------------------------------
    -- CONTROL / RAINBOW SPEED
    ------------------------------------------------------------------------

    CreateSectionDivider("CONTROL", 5.5)

    local rainbowSpeedCard = createCard(
        settingsScroll,
        116,
        5.7
    )

    local rainbowSpeedTitle = createLabel(
        rainbowSpeedCard,
        "Rainbow Speed",
        UDim2.new(1, -75, 0, 18),
        UDim2.new(0, 16, 0, 7),
        Enum.Font.GothamBold,
        11
    )

    local rainbowSpeedPercentLabel = Instance.new("TextLabel")
    rainbowSpeedPercentLabel.Parent = rainbowSpeedCard
    rainbowSpeedPercentLabel.Size = UDim2.new(0, 55, 0, 18)
    rainbowSpeedPercentLabel.Position = UDim2.new(1, -68, 0, 7)
    rainbowSpeedPercentLabel.BackgroundTransparency = 1
    rainbowSpeedPercentLabel.Font = Enum.Font.GothamBold
    rainbowSpeedPercentLabel.TextSize = 11
    rainbowSpeedPercentLabel.TextColor3 = Config.ThemeColor
    rainbowSpeedPercentLabel.Text = tostring(Config.RainbowSpeedPercent) .. "%"
    rainbowSpeedPercentLabel.TextXAlignment = Enum.TextXAlignment.Right
    rainbowSpeedPercentLabel.ZIndex = 205
    safeInsert(allThemeTexts, rainbowSpeedPercentLabel)

    local rainbowSpeedBar = Instance.new("Frame")
    rainbowSpeedBar.Parent = rainbowSpeedCard
    rainbowSpeedBar.Size = UDim2.new(1, -32, 0, 7)
    rainbowSpeedBar.Position = UDim2.new(0, 16, 0, 35)
    rainbowSpeedBar.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
    rainbowSpeedBar.BorderSizePixel = 0
    rainbowSpeedBar.ZIndex = 204
    corner(rainbowSpeedBar, 99)

    local rainbowSpeedFill = Instance.new("Frame")
    rainbowSpeedFill.Parent = rainbowSpeedBar
    rainbowSpeedFill.Size = UDim2.new(
        math.clamp(Config.RainbowSpeedPercent / 300, 0, 1),
        0,
        1,
        0
    )
    rainbowSpeedFill.BackgroundColor3 = Config.ThemeColor
    rainbowSpeedFill.BorderSizePixel = 0
    rainbowSpeedFill.ZIndex = 205
    corner(rainbowSpeedFill, 99)
    safeInsert(allHubLines, rainbowSpeedFill)

    local rainbowSpeedSliderBtn = Instance.new("TextButton")
    rainbowSpeedSliderBtn.Parent = rainbowSpeedBar
    rainbowSpeedSliderBtn.Size = UDim2.new(0, 14, 0, 18)
    rainbowSpeedSliderBtn.Position = UDim2.new(
        math.clamp(Config.RainbowSpeedPercent / 300, 0, 1),
        -7,
        0.5,
        -9
    )
    rainbowSpeedSliderBtn.BackgroundColor3 = Color3.fromRGB(248, 249, 255)
    rainbowSpeedSliderBtn.Text = ""
    rainbowSpeedSliderBtn.AutoButtonColor = false
    rainbowSpeedSliderBtn.ZIndex = 207
    corner(rainbowSpeedSliderBtn, 99)
    stroke(rainbowSpeedSliderBtn, Config.ThemeColor, 1, 0.15)

    local rainbowSpeedInput = Instance.new("TextBox")
    rainbowSpeedInput.Parent = rainbowSpeedCard
    rainbowSpeedInput.Size = UDim2.new(1, -32, 0, 28)
    rainbowSpeedInput.Position = UDim2.new(0, 16, 0, 51)
    rainbowSpeedInput.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
    rainbowSpeedInput.BackgroundTransparency = 0.1
    rainbowSpeedInput.BorderSizePixel = 0
    rainbowSpeedInput.Font = Enum.Font.Code
    rainbowSpeedInput.TextSize = 11
    rainbowSpeedInput.TextColor3 = Color3.fromRGB(245, 247, 255)
    rainbowSpeedInput.Text = tostring(Config.RainbowSpeedPercent)
    rainbowSpeedInput.PlaceholderText = "10 - 300"
    rainbowSpeedInput.ClearTextOnFocus = false
    rainbowSpeedInput.TextXAlignment = Enum.TextXAlignment.Center
    rainbowSpeedInput.ZIndex = 205
    corner(rainbowSpeedInput, 7)
    stroke(rainbowSpeedInput, Config.ThemeColor, 1, 0.3)

    local rainbowSpeedNote = Instance.new("TextLabel")
    rainbowSpeedNote.Parent = rainbowSpeedCard
    rainbowSpeedNote.Size = UDim2.new(1, -32, 0, 14)
    rainbowSpeedNote.Position = UDim2.new(0, 16, 0, 88)
    rainbowSpeedNote.BackgroundTransparency = 1
    rainbowSpeedNote.Font = Enum.Font.Code
    rainbowSpeedNote.TextSize = 8
    rainbowSpeedNote.TextColor3 = Color3.fromRGB(105, 110, 128)
    rainbowSpeedNote.Text = "SPEED RANGE  •  10 — 300%"
    rainbowSpeedNote.TextXAlignment = Enum.TextXAlignment.Center
    rainbowSpeedNote.ZIndex = 205

    local function SetRainbowSpeedPercent(value)
        value = math.clamp(
            math.floor((tonumber(value) or Config.RainbowSpeedPercent) + 0.5),
            10,
            300
        )

        Config.RainbowSpeedPercent = value

        local normalized = value / 300

        rainbowSpeedFill.Size = UDim2.new(normalized, 0, 1, 0)
        rainbowSpeedSliderBtn.Position = UDim2.new(
            normalized,
            -7,
            0.5,
            -9
        )

        rainbowSpeedInput.Text = tostring(value)
        rainbowSpeedPercentLabel.Text = tostring(value) .. "%"

        return value
    end

    SetRainbowSpeedPercent(Config.RainbowSpeedPercent)

    rainbowSpeedSliderBtn.MouseButton1Down:Connect(function()
        rainbowSpeedDragging = true
    end)

    rainbowSpeedBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            rainbowSpeedDragging = true
        end
    end)

    rainbowSpeedInput.FocusLost:Connect(function()
        local value = tonumber(rainbowSpeedInput.Text)
        if value then
            SetRainbowSpeedPercent(value)
        else
            rainbowSpeedInput.Text = tostring(Config.RainbowSpeedPercent)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not rainbowSpeedDragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

        local barX = rainbowSpeedBar.AbsolutePosition.X
        local barWidth = rainbowSpeedBar.AbsoluteSize.X

        if barWidth <= 0 then return end

        local mouseX = UserInputService:GetMouseLocation().X
        local normalized = math.clamp(
            (mouseX - barX) / barWidth,
            0,
            1
        )

        SetRainbowSpeedPercent(10 + normalized * 290)
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            rainbowSpeedDragging = false
        end
    end)

    ------------------------------------------------------------------------
    -- DEBUG
    ------------------------------------------------------------------------

    local debugToggleCard = createCard(
        settingsScroll,
        44,
        6
    )

    local debugToggleLbl = createLabel(
        debugToggleCard,
        "Show Debug Info",
        UDim2.new(1, -70, 1, 0),
        UDim2.new(0, 16, 0, 0),
        Enum.Font.GothamBold,
        11
    )

    local debugSub = createLabel(
        debugToggleCard,
        "LIVE DIAGNOSTICS",
        UDim2.new(0, 110, 0, 12),
        UDim2.new(0, 16, 1, -15),
        Enum.Font.Code,
        7
    )
    debugSub.TextColor3 = Color3.fromRGB(110, 115, 132)

    local debugToggleBox = Instance.new("Frame")
    debugToggleBox.Parent = debugToggleCard
    debugToggleBox.Size = UDim2.new(0, 36, 0, 19)
    debugToggleBox.Position = UDim2.new(1, -48, 0.5, -9)
    debugToggleBox.BackgroundColor3 = Color3.fromRGB(13, 15, 22)
    debugToggleBox.BorderSizePixel = 0
    debugToggleBox.ZIndex = 205
    corner(debugToggleBox, 99)

    local debugToggleStroke = stroke(
        debugToggleBox,
        Config.ThemeColor,
        1.5,
        0.1
    )

    local debugToggleCircle = Instance.new("Frame")
    debugToggleCircle.Parent = debugToggleBox
    debugToggleCircle.Size = UDim2.new(0, 11, 0, 11)
    debugToggleCircle.Position = Config.ShowDebug
        and UDim2.new(1, -16, 0.5, 0)
        or UDim2.new(0, 5, 0.5, 0)
    debugToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
    debugToggleCircle.BackgroundColor3 = Config.ThemeColor
    debugToggleCircle.BorderSizePixel = 0
    debugToggleCircle.ZIndex = 206
    corner(debugToggleCircle, 99)

    local debugClickArea = Instance.new("TextButton")
    debugClickArea.Parent = debugToggleCard
    debugClickArea.Size = UDim2.fromScale(1,1)
    debugClickArea.BackgroundTransparency = 1
    debugClickArea.Text = ""
    debugClickArea.AutoButtonColor = false
    debugClickArea.ZIndex = 210

    ------------------------------------------------------------------------
    -- HOTKEY
    ------------------------------------------------------------------------

    CreateSectionDivider("HOTKEY", 6.5)

    local hotkeyCard = createCard(
        settingsScroll,
        54,
        7
    )

    local hotkeyLbl = createLabel(
        hotkeyCard,
        "Toggle Hotkey",
        UDim2.new(0, 112, 1, 0),
        UDim2.new(0, 16, 0, 0),
        Enum.Font.GothamBold,
        11
    )

    local hotkeyHint = createLabel(
        hotkeyCard,
        "PRESS TO CHANGE",
        UDim2.new(0, 110, 0, 12),
        UDim2.new(0, 16, 1, -16),
        Enum.Font.Code,
        7
    )
    hotkeyHint.TextColor3 = Color3.fromRGB(110, 115, 132)

    local hotkeyButtonBox = Instance.new("TextButton")
    hotkeyButtonBox.Parent = hotkeyCard
    hotkeyButtonBox.Size = UDim2.new(0, 96, 0, 31)
    hotkeyButtonBox.Position = UDim2.new(1, -108, 0.5, -15.5)
    hotkeyButtonBox.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
    hotkeyButtonBox.BackgroundTransparency = 0.05
    hotkeyButtonBox.BorderSizePixel = 0
    hotkeyButtonBox.Font = Enum.Font.GothamBold
    hotkeyButtonBox.TextSize = 11
    hotkeyButtonBox.TextColor3 = Config.ThemeColor
    hotkeyButtonBox.Text = tostring(Config.ToggleKey.Name)
    hotkeyButtonBox.AutoButtonColor = false
    hotkeyButtonBox.ZIndex = 205
    corner(hotkeyButtonBox, 7)
    stroke(hotkeyButtonBox, Config.ThemeColor, 1, 0.15)
    safeInsert(allThemeTexts, hotkeyButtonBox)

    hotkeyButtonBox.MouseEnter:Connect(function()
        TweenService:Create(
            hotkeyButtonBox,
            TweenInfo.new(0.18, Enum.EasingStyle.Quint),
            {BackgroundColor3 = Color3.fromRGB(28, 31, 43)}
        ):Play()
    end)

    hotkeyButtonBox.MouseLeave:Connect(function()
        TweenService:Create(
            hotkeyButtonBox,
            TweenInfo.new(0.18, Enum.EasingStyle.Quint),
            {BackgroundColor3 = Color3.fromRGB(12, 14, 20)}
        ):Play()
    end)

    hotkeyButtonBox.MouseButton1Click:Connect(function()
        if listeningKey then return end

        listeningKey = true
        hotkeyButtonBox.Text = "PRESS KEY..."
        hotkeyButtonBox.TextColor3 = Color3.fromRGB(255, 205, 80)

        local connection

        connection = UserInputService.InputBegan:Connect(function(
            input,
            gameProcessed
        )
            if gameProcessed then
                return
            end

            if input.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end

            Config.ToggleKey = input.KeyCode
            hotkeyButtonBox.Text = tostring(input.KeyCode.Name)
            hotkeyButtonBox.TextColor3 = Config.ThemeColor
            listeningKey = false

            ShowNotification(
                "Hotkey changed to: " .. tostring(input.KeyCode.Name)
            )

            if connection then
                connection:Disconnect()
                connection = nil
            end
        end)
    end)

    ------------------------------------------------------------------------
    -- THEME ENGINE
    ------------------------------------------------------------------------

    ApplyGlobalTheme = function(newColor)
        if typeof(newColor) ~= "Color3" then
            return
        end

        Config.ThemeColor = newColor

        if not isRainbowRunning and not rainbowTransitionActive then
            staticThemeColor = newColor
        end

        if mainStroke then
            mainStroke.Color = newColor
        end

        if glowBorder then
            glowBorder.Color = newColor
        end

        settingsStroke.Color = newColor
        settingsGlow.Color = newColor
        paletteStroke.Color = newColor
        applyStroke.Color = newColor

        if openStroke then
            openStroke.Color = newColor
        end

        if openGlow then
            openGlow.Color = newColor
        end

        if openAccent then
            openAccent.BackgroundColor3 = newColor
        end

        if openStatus then
            openStatus.TextColor3 = newColor
        end

        if openIcon then
            openIcon.TextColor3 = newColor
        end

        if lineStroke then
            lineStroke.Color = newColor
        end

        if applyThemeBtn then
            applyThemeBtn.BackgroundColor3 = newColor
        end

        rainbowToggleStroke.Color = newColor
        rainbowToggleCircle.BackgroundColor3 = newColor
        debugToggleStroke.Color = newColor
        debugToggleCircle.BackgroundColor3 = newColor
        hotkeyButtonBox.TextColor3 = newColor
        rainbowSpeedPercentLabel.TextColor3 = newColor
        rainbowSpeedFill.BackgroundColor3 = newColor
        palettePreview.BackgroundColor3 = selectedThemeColor

        for _, txtObj in ipairs(allThemeTexts) do
            if txtObj and txtObj.Parent then
                txtObj.TextColor3 = newColor
            end
        end

        for _, lineObj in ipairs(allHubLines) do
            if lineObj and lineObj.Parent then
                lineObj.BackgroundColor3 = newColor
            end
        end

        for _, object in ipairs(settingsWindow:GetDescendants()) do
            if object:IsA("UIStroke") and object ~= svCursor:FindFirstChildOfClass("UIStroke")
                and object ~= hueCursor:FindFirstChildOfClass("UIStroke") then
                if object.Name ~= "SoftShadow" then
                    object.Color = newColor
                end
            elseif object:IsA("Frame") and object.Name == "AccentBar" then
                object.BackgroundColor3 = newColor
            end
        end
    end

    local function UpdateToggleIndicators(accentColor)
        accentColor = accentColor or Config.ThemeColor

        rainbowToggleStroke.Color = accentColor
        rainbowToggleCircle.BackgroundColor3 = accentColor
        rainbowToggleCircle.Position = isRainbowRunning
            and UDim2.new(1, -16, 0.5, 0)
            or UDim2.new(0, 5, 0.5, 0)

        debugToggleStroke.Color = accentColor
        debugToggleCircle.BackgroundColor3 = accentColor
        debugToggleCircle.Position = Config.ShowDebug
            and UDim2.new(1, -16, 0.5, 0)
            or UDim2.new(0, 5, 0.5, 0)
    end

    UpdateToggleIndicators(Config.ThemeColor)
    RefreshPickerLock()

    ------------------------------------------------------------------------
    -- RAINBOW ENGINE
    ------------------------------------------------------------------------

    task.spawn(function()
        while gui and gui.Parent and not destroyed do
            if isRainbowRunning
                and not rainbowTransitionActive
                and not isThemeLoading() then

                rainbowHue = (
                    rainbowHue
                    + (0.0025 * (Config.RainbowSpeedPercent / 100))
                ) % 1

                local rainbowColor = Color3.fromHSV(
                    rainbowHue,
                    1,
                    1
                )

                ApplyGlobalTheme(rainbowColor)
                UpdateToggleIndicators(rainbowColor)

                pickerHue = rainbowHue
                pickerSaturation = 1
                pickerValue = 1
                UpdateThemePicker()

                palettePreview.BackgroundColor3 = rainbowColor

                local rr = rainbowColor.R * 255
                local gg = rainbowColor.G * 255
                local bb = rainbowColor.B * 255

                paletteValue.Text = string.format(
                    "#%02X%02X%02X",
                    math.floor(rr + 0.5),
                    math.floor(gg + 0.5),
                    math.floor(bb + 0.5)
                )

                for _, strokeObj in ipairs(allHubStrokes) do
                    if strokeObj
                        and strokeObj.Parent
                        and not contentHoverRegistry[strokeObj] then
                        strokeObj.Color = rainbowColor
                    end
                end

                for strokeObj, state in pairs(contentHoverRegistry) do
                    if strokeObj and strokeObj.Parent then
                        if state.hovered then
                            strokeObj.Color = rainbowColor
                            if state.glow then
                                state.glow.BackgroundColor3 = rainbowColor
                            end
                        else
                            strokeObj.Color = CONTENT_BORDER_COLOR
                        end
                    end
                end

                local currentActiveTab = getActiveTabName()

                for name, btn in pairs(tabButtons) do
                    if btn and btn.Parent then
                        local btnStroke = btn:FindFirstChildOfClass("UIStroke")

                        if name == currentActiveTab then
                            btn.BackgroundColor3 = rainbowColor
                            btn.TextColor3 = Color3.fromRGB(30, 30, 40)

                            if btnStroke then
                                btnStroke.Color = rainbowColor
                            end
                        else
                            btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
                            btn.TextColor3 = rainbowColor

                            if btnStroke then
                                btnStroke.Color = rainbowColor
                            end
                        end
                    end
                end
            elseif not isRainbowRunning
                and not rainbowTransitionActive
                and not isThemeLoading() then

                ApplyGlobalTheme(staticThemeColor)
                UpdateToggleIndicators(staticThemeColor)

                for _, strokeObj in ipairs(allHubStrokes) do
                    if strokeObj
                        and strokeObj.Parent
                        and not contentHoverRegistry[strokeObj] then
                        strokeObj.Color = staticThemeColor
                    end
                end

                local currentActiveTab = getActiveTabName()

                for name, btn in pairs(tabButtons) do
                    if btn and btn.Parent then
                        local btnStroke = btn:FindFirstChildOfClass("UIStroke")

                        if name == currentActiveTab then
                            btn.BackgroundColor3 = staticThemeColor
                            btn.TextColor3 = Color3.fromRGB(30, 30, 40)
                        else
                            btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
                            btn.TextColor3 = Color3.fromRGB(230, 230, 240)
                        end

                        if btnStroke then
                            btnStroke.Color = staticThemeColor
                        end
                    end
                end
            end

            task.wait(0.03)
        end
    end)

    ------------------------------------------------------------------------
    -- RAINBOW TOGGLE
    ------------------------------------------------------------------------

    rainbowClickArea.MouseButton1Click:Connect(function()
        if isThemeLoading() or rainbowTransitionActive then
            return
        end

        local enableRainbow = not isRainbowRunning

        rainbowTransitionSerial += 1
        local transitionSerial = rainbowTransitionSerial

        rainbowTransitionActive = true

        if enableRainbow then
            isRainbowRunning = true
            RefreshPickerLock()

            staticThemeColor = Config.ThemeColor
            rainbowHue = select(1, staticThemeColor:ToHSV())

            local firstRainbowColor = Color3.fromHSV(
                rainbowHue,
                1,
                1
            )

            if not PlayAdvancedThemeLoading(
                firstRainbowColor,
                "RAINBOW MODE",
                "Starting Rainbow Continuous"
            ) then
                isRainbowRunning = false
                rainbowTransitionActive = false
                RefreshPickerLock()
                return
            end

            task.spawn(function()
                local token = getLoadingAnimationToken()

                task.wait(THEME_LOADING_APPLY_DELAY)

                if transitionSerial ~= rainbowTransitionSerial
                    or token ~= getLoadingAnimationToken()
                    or not isThemeLoading()
                    or not loadingScreen.Parent then

                    rainbowTransitionActive = false
                    RefreshPickerLock()
                    setThemeLoading(false)
                    StopLoadingAnimation()
                    RestoreUIAfterThemeLoading()
                    return
                end

                isRainbowRunning = true
                rainbowTransitionActive = false
                RefreshPickerLock()

                Config.ThemeColor = firstRainbowColor
                UpdateLoadingTheme()

                pcall(function()
                    ApplyGlobalTheme(firstRainbowColor)
                end)

                selectedThemeColor = firstRainbowColor
                palettePreview.BackgroundColor3 = firstRainbowColor

                local fr = firstRainbowColor.R * 255
                local fg = firstRainbowColor.G * 255
                local fb = firstRainbowColor.B * 255

                paletteValue.Text = string.format(
                    "#%02X%02X%02X",
                    math.floor(fr + 0.5),
                    math.floor(fg + 0.5),
                    math.floor(fb + 0.5)
                )

                UpdateToggleIndicators(firstRainbowColor)

                loadingStatus.Text = "RAINBOW ACTIVE"

                TweenService:Create(
                    progressFill,
                    TweenInfo.new(
                        0.28,
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ),
                    {Size = UDim2.new(1, 0, 1, 0)}
                ):Play()

                task.delay(0.35, function()
                    if isThemeLoading() then
                        FinishAdvancedThemeLoading()
                    end
                end)
            end)

            ShowNotification("Rainbow Continuous Loading...")
        else
            local restoreColor = staticThemeColor

            isRainbowRunning = false
            RefreshPickerLock()

            if not PlayAdvancedThemeLoading(
                restoreColor,
                "RAINBOW MODE",
                "Returning To Static Theme"
            ) then
                rainbowTransitionActive = false
                RefreshPickerLock()
                return
            end

            task.spawn(function()
                local token = getLoadingAnimationToken()

                task.wait(THEME_LOADING_APPLY_DELAY)

                if transitionSerial ~= rainbowTransitionSerial
                    or token ~= getLoadingAnimationToken()
                    or not isThemeLoading()
                    or not loadingScreen.Parent then

                    rainbowTransitionActive = false
                    RefreshPickerLock()
                    setThemeLoading(false)
                    StopLoadingAnimation()
                    RestoreUIAfterThemeLoading()
                    return
                end

                Config.ThemeColor = restoreColor

                pcall(function()
                    ApplyGlobalTheme(restoreColor)
                end)

                pickerHue, pickerSaturation, pickerValue = restoreColor:ToHSV()
                selectedThemeColor = restoreColor

                rainbowTransitionActive = false
                RefreshPickerLock()

                UpdateLoadingTheme()
                UpdateToggleIndicators(restoreColor)

                loadingStatus.Text = "THEME RESTORED"

                TweenService:Create(
                    progressFill,
                    TweenInfo.new(
                        0.28,
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ),
                    {Size = UDim2.new(1, 0, 1, 0)}
                ):Play()

                task.delay(0.35, function()
                    if isThemeLoading() then
                        FinishAdvancedThemeLoading()
                    end
                end)
            end)

            ShowNotification("Rainbow Continuous Stopping...")
        end
    end)

    ------------------------------------------------------------------------
    -- DEBUG TOGGLE
    ------------------------------------------------------------------------

    local function SetDebugVisibility(enabled)
        Config.ShowDebug = enabled == true

        if debugToggleCircle then
            debugToggleCircle.Visible = true
            debugToggleCircle.Position = Config.ShowDebug
                and UDim2.new(1, -16, 0.5, 0)
                or UDim2.new(0, 5, 0.5, 0)
        end

        if debugSidebarFrame then
            debugSidebarFrame.Visible = Config.ShowDebug
        end

        if keyStatusSidebarFrame then
            keyStatusSidebarFrame.Visible = Config.ShowDebug
        end

        if debugDividerBetween then
            debugDividerBetween.Visible = Config.ShowDebug
        end

        UpdateToggleIndicators(Config.ThemeColor)
    end

    debugClickArea.Active = true
    debugClickArea.AutoButtonColor = false

    debugClickArea.Activated:Connect(function()
        SetDebugVisibility(not Config.ShowDebug)

        if Config.ShowDebug then
            ShowNotification("Debug Info Enabled!")
        else
            ShowNotification("Debug Info Disabled!")
        end
    end)

    ------------------------------------------------------------------------
    -- APPLY THEME
    ------------------------------------------------------------------------

    applyThemeBtn.MouseButton1Click:Connect(function()
        if isThemeLoading() or rainbowTransitionActive then
            return
        end

        local targetColor = selectedThemeColor

        if typeof(targetColor) ~= "Color3" then
            return
        end

        rainbowTransitionSerial += 1
        local applySerial = rainbowTransitionSerial

        isRainbowRunning = false
        rainbowTransitionActive = true
        RefreshPickerLock()

        staticThemeColor = targetColor

        local started = PlayAdvancedThemeLoading(
            targetColor,
            "FISHHUB",
            "Applying Theme & Reloading UI"
        )

        if not started then
            rainbowTransitionActive = false
            RefreshPickerLock()
            return
        end

        ShowNotification("Applying theme...")

        task.spawn(function()
            task.wait(THEME_LOADING_APPLY_DELAY)

            if applySerial ~= rainbowTransitionSerial
                or not isThemeLoading()
                or not loadingScreen.Parent then

                rainbowTransitionActive = false
                RefreshPickerLock()
                setThemeLoading(false)
                RestoreUIAfterThemeLoading()
                return
            end

            local ok = pcall(
                ApplyGlobalTheme,
                targetColor
            )

            if not ok then
                Config.ThemeColor = targetColor
                UpdateLoadingTheme()
            end

            selectedThemeColor = targetColor
            pickerHue, pickerSaturation, pickerValue = targetColor:ToHSV()

            loadingStatus.Text = ok
                and "THEME APPLIED"
                or "THEME APPLIED WITH SAFE RECOVERY"

            TweenService:Create(
                progressFill,
                TweenInfo.new(
                    0.45,
                    Enum.EasingStyle.Quint,
                    Enum.EasingDirection.Out
                ),
                {Size = UDim2.new(1, 0, 1, 0)}
            ):Play()

            task.delay(0.5, function()
                rainbowTransitionActive = false
                RefreshPickerLock()

                if isThemeLoading() then
                    FinishAdvancedThemeLoading()
                end
            end)

            ShowNotification(
                "Theme applied successfully to UI & Lines!"
            )
        end)
    end)

    ------------------------------------------------------------------------
    -- SETTINGS OPEN / CLOSE
    ------------------------------------------------------------------------

    local function PositionSettings()
        if not settingsWindow or not settingsWindow.Parent then
            return
        end

        if not main.Visible then
            return
        end

        local scale = mainScale.Scale
        local scaledMainHalfWidth = (
            Config.MainWidth * scale
        ) / 2

        settingsWindow.Position = UDim2.new(
            0.5,
            scaledMainHalfWidth + 10,
            0.5,
            0
        )
    end

    task.spawn(function()
        while gui and gui.Parent and not destroyed do
            PositionSettings()
            task.wait()
        end
    end)

    local function CloseSettings()
        if settingsWindow and settingsWindow.Parent then
            settingsWindow.Visible = false
        end
    end

    local function ToggleSettings()
        if destroyed then
            return
        end

        if settingsWindow.Visible then
            settingsWindow.Visible = false
        else
            PositionSettings()
            settingsWindow.Visible = true
        end
    end

    main:GetPropertyChangedSignal("Visible"):Connect(function()
        if not main.Visible then
            CloseSettings()
        end
    end)

    ------------------------------------------------------------------------
    -- INITIAL VISUAL STATE
    ------------------------------------------------------------------------

    SetDebugVisibility(Config.ShowDebug)
    RefreshPickerLock()
    UpdateThemePicker()
    UpdateToggleIndicators(Config.ThemeColor)

    ------------------------------------------------------------------------
    -- CONTROLLER API
    ------------------------------------------------------------------------

    return {
        Toggle = ToggleSettings,

        Open = function()
            if settingsWindow then
                PositionSettings()
                settingsWindow.Visible = true
            end
        end,

        Close = CloseSettings,

        IsOpen = function()
            return settingsWindow
                and settingsWindow.Visible == true
        end,

        IsRainbowRunning = function()
            return isRainbowRunning
        end,

        IsListeningKey = function()
            return listeningKey == true
        end,

        IsRainbowTransitioning = function()
            return rainbowTransitionActive
        end,

        GetCurrentAccentColor = function()
            if isRainbowRunning
                and not rainbowTransitionActive
                and not isThemeLoading() then
                return Color3.fromHSV(
                    rainbowHue,
                    1,
                    1
                )
            end

            return Config.ThemeColor
        end,

        ApplyTheme = ApplyGlobalTheme,

        SetDebugVisibility = SetDebugVisibility,

        Destroy = function()
            destroyed = true
            CloseSettings()

            if settingsWindow then
                settingsWindow:Destroy()
            end
        end,
    }
end