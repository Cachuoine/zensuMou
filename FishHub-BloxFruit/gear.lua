--// FishHub | Gear.lua
--// Factory contract preserved: chunk() -> factory(context) -> controller.
return function(context)
    context = context or {}

    local TweenService = context.TweenService or game:GetService("TweenService")
    local UserInputService = context.UserInputService or game:GetService("UserInputService")
    local Players = context.Players or game:GetService("Players")
    local player = Players.LocalPlayer

    local gui = context.gui
    local main = context.main
    local Config = context.Config or {}

    local function accent()
        return typeof(Config.ThemeColor) == "Color3"
            and Config.ThemeColor
            or Color3.fromRGB(0, 229, 255)
    end

    local function New(className, props)
        local obj = Instance.new(className)
        for k, v in pairs(props or {}) do obj[k] = v end
        return obj
    end

    local function Corner(parent, radius)
        return New("UICorner", {
            Parent = parent,
            CornerRadius = UDim.new(0, radius)
        })
    end

    local function Stroke(parent, thickness, transparency)
        return New("UIStroke", {
            Parent = parent,
            Color = accent(),
            Thickness = thickness or 1,
            Transparency = transparency or 0.5
        })
    end

    local function Tween(obj, duration, props, style, direction)
        local t = TweenService:Create(
            obj,
            TweenInfo.new(
                duration or 0.2,
                style or Enum.EasingStyle.Quint,
                direction or Enum.EasingDirection.Out
            ),
            props
        )
        t:Play()
        return t
    end

    local settings = gui and gui:FindFirstChild("SettingsWindow")
    if settings then settings:Destroy() end

    settings = New("Frame", {
        Name = "SettingsWindow",
        Parent = gui,
        Size = UDim2.new(0, 440, 0, 360),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(11, 12, 18),
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 500
    })
    Corner(settings, 16)
    local outerStroke = Stroke(settings, 1.5, 0.12)

    local scale = New("UIScale", {Parent = settings, Scale = 0.92})

    local header = New("Frame", {
        Parent = settings,
        Size = UDim2.new(1, -24, 0, 58),
        Position = UDim2.fromOffset(12, 12),
        BackgroundColor3 = Color3.fromRGB(16, 18, 27),
        BorderSizePixel = 0
    })
    Corner(header, 13)
    local headerStroke = Stroke(header, 1, 0.42)

    local icon = New("Frame", {
        Parent = header,
        Position = UDim2.fromOffset(13, 11),
        Size = UDim2.fromOffset(36, 36),
        BackgroundColor3 = Color3.fromRGB(22, 24, 35),
        BorderSizePixel = 0
    })
    Corner(icon, 10)
    local iconStroke = Stroke(icon, 1, 0.35)

    New("TextLabel", {
        Parent = icon,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "⚙",
        Font = Enum.Font.GothamBold,
        TextSize = 17,
        TextColor3 = accent()
    })

    New("TextLabel", {
        Parent = header,
        Position = UDim2.fromOffset(62, 10),
        Size = UDim2.new(1, -74, 0, 22),
        BackgroundTransparency = 1,
        Text = "GEAR & SETTINGS",
        Font = Enum.Font.GothamBlack,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(245, 246, 252),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    New("TextLabel", {
        Parent = header,
        Position = UDim2.fromOffset(62, 32),
        Size = UDim2.new(1, -74, 0, 15),
        BackgroundTransparency = 1,
        Text = "CONTROL  •  APPEARANCE  •  HOTKEY",
        Font = Enum.Font.GothamMedium,
        TextSize = 7,
        TextColor3 = Color3.fromRGB(115, 120, 135),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local close = New("TextButton", {
        Parent = header,
        Position = UDim2.new(1, -42, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(28, 28),
        BackgroundColor3 = Color3.fromRGB(23, 25, 34),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(190, 194, 205)
    })
    Corner(close, 9)

    local body = New("Frame", {
        Parent = settings,
        Position = UDim2.fromOffset(12, 82),
        Size = UDim2.new(1, -24, 1, -94),
        BackgroundTransparency = 1
    })

    local bodyLayout = New("UIListLayout", {
        Parent = body,
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local function makeSection(title, subtitle, order)
        local card = New("Frame", {
            Parent = body,
            LayoutOrder = order,
            Size = UDim2.new(1, 0, 0, 74),
            BackgroundColor3 = Color3.fromRGB(14, 16, 24),
            BorderSizePixel = 0
        })
        Corner(card, 12)
        local st = Stroke(card, 1, 0.68)

        New("Frame", {
            Parent = card,
            Position = UDim2.fromOffset(10, 12),
            Size = UDim2.fromOffset(3, 50),
            BackgroundColor3 = accent(),
            BorderSizePixel = 0
        })
        Corner(card:FindFirstChildOfClass("Frame") or card, 3)

        New("TextLabel", {
            Parent = card,
            Position = UDim2.fromOffset(25, 12),
            Size = UDim2.new(1, -42, 0, 20),
            BackgroundTransparency = 1,
            Text = title,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextColor3 = Color3.fromRGB(240, 242, 248),
            TextXAlignment = Enum.TextXAlignment.Left
        })

        New("TextLabel", {
            Parent = card,
            Position = UDim2.fromOffset(25, 34),
            Size = UDim2.new(1, -42, 0, 28),
            BackgroundTransparency = 1,
            Text = subtitle,
            Font = Enum.Font.GothamMedium,
            TextSize = 8,
            TextColor3 = Color3.fromRGB(110, 115, 130),
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })

        return card, st
    end

    local themeCard, themeStroke = makeSection(
        "THEME",
        "Use the active accent color supplied by FishHub.",
        1
    )

    local themeButton = New("TextButton", {
        Parent = themeCard,
        Position = UDim2.new(1, -118, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(96, 32),
        BackgroundColor3 = Color3.fromRGB(20, 22, 31),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "APPLY",
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = Color3.fromRGB(240, 242, 248)
    })
    Corner(themeButton, 9)
    local themeButtonStroke = Stroke(themeButton, 1, 0.38)

    local keyCard, keyStroke = makeSection(
        "TOGGLE KEY",
        "Current keyboard shortcut used to open or close the hub.",
        2
    )

    local keyButton = New("TextButton", {
        Parent = keyCard,
        Position = UDim2.new(1, -118, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(96, 32),
        BackgroundColor3 = Color3.fromRGB(20, 22, 31),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = tostring(Config.ToggleKey and Config.ToggleKey.Name or "K"),
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = Color3.fromRGB(240, 242, 248)
    })
    Corner(keyButton, 9)
    local keyButtonStroke = Stroke(keyButton, 1, 0.38)

    local infoCard, infoStroke = makeSection(
        "UI STATUS",
        "FishHub visual system is active. Settings are kept separate from the main tab layout.",
        3
    )

    local listening = false

    local function setAccent(color)
        if typeof(color) ~= "Color3" then return end
        Config.ThemeColor = color
        if context.UpdateLoadingTheme then pcall(context.UpdateLoadingTheme) end
        outerStroke.Color = color
        headerStroke.Color = color
        iconStroke.Color = color
        themeStroke.Color = color
        keyStroke.Color = color
        infoStroke.Color = color
        themeButtonStroke.Color = color
        keyButtonStroke.Color = color
    end

    local function applyTheme()
        local color = accent()
        if context.PlayAdvancedThemeLoading then
            context.PlayAdvancedThemeLoading(color, "FISHHUB", "Refreshing interface")
            task.delay(
                tonumber(context.THEME_LOADING_APPLY_DELAY) or 2.15,
                function()
                    if context.FinishAdvancedThemeLoading then
                        context.FinishAdvancedThemeLoading()
                    end
                end
            )
        else
            setAccent(color)
        end
    end

    themeButton.Activated:Connect(applyTheme)

    keyButton.Activated:Connect(function()
        if listening then return end
        listening = true
        keyButton.Text = "PRESS KEY..."
        Tween(keyButtonStroke, 0.15, {Transparency = 0.05, Thickness = 1.5})

        local connection
        connection = UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if input.KeyCode == Enum.KeyCode.Unknown then return end

            Config.ToggleKey = input.KeyCode
            keyButton.Text = input.KeyCode.Name
            listening = false
            if connection then connection:Disconnect() end
            Tween(keyButtonStroke, 0.15, {Transparency = 0.38, Thickness = 1})
        end)
    end)

    close.Activated:Connect(function()
        settings.Visible = false
    end)

    close.MouseEnter:Connect(function()
        Tween(close, 0.15, {
            BackgroundColor3 = Color3.fromRGB(30, 33, 44),
            TextColor3 = accent()
        })
    end)
    close.MouseLeave:Connect(function()
        Tween(close, 0.15, {
            BackgroundColor3 = Color3.fromRGB(23, 25, 34),
            TextColor3 = Color3.fromRGB(190, 194, 205)
        })
    end)

    themeButton.MouseEnter:Connect(function()
        Tween(themeButton, 0.16, {BackgroundColor3 = Color3.fromRGB(27, 30, 42)})
        Tween(themeButtonStroke, 0.16, {Transparency = 0.05, Thickness = 1.4})
    end)
    themeButton.MouseLeave:Connect(function()
        Tween(themeButton, 0.16, {BackgroundColor3 = Color3.fromRGB(20, 22, 31)})
        Tween(themeButtonStroke, 0.16, {Transparency = 0.38, Thickness = 1})
    end)

    keyButton.MouseEnter:Connect(function()
        Tween(keyButton, 0.16, {BackgroundColor3 = Color3.fromRGB(27, 30, 42)})
        Tween(keyButtonStroke, 0.16, {Transparency = 0.05, Thickness = 1.4})
    end)
    keyButton.MouseLeave:Connect(function()
        if not listening then
            Tween(keyButton, 0.16, {BackgroundColor3 = Color3.fromRGB(20, 22, 31)})
            Tween(keyButtonStroke, 0.16, {Transparency = 0.38, Thickness = 1})
        end
    end)

    task.spawn(function()
        while settings.Parent do
            local a = accent()
            outerStroke.Color = a
            headerStroke.Color = a
            iconStroke.Color = a
            themeStroke.Color = a
            keyStroke.Color = a
            infoStroke.Color = a
            themeButtonStroke.Color = a
            keyButtonStroke.Color = a
            task.wait(0.2)
        end
    end)

    local controller = {}

    function controller:Toggle()
        if settings.Visible then
            self:Close()
            return
        end

        settings.Visible = true
        scale.Scale = 0.92
        Tween(scale, 0.28, {Scale = 1}, Enum.EasingStyle.Back)
    end

    function controller:Close()
        if not settings.Visible then return end
        Tween(scale, 0.2, {Scale = 0.92}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.delay(0.2, function()
            if settings and settings.Parent then
                settings.Visible = false
                scale.Scale = 0.92
            end
        end)
    end

    function controller:IsListeningKey()
        return listening
    end

    controller.IsListeningKey = function()
        return listening
    end

    function controller:GetCurrentAccentColor()
        return accent()
    end

    return controller
end
