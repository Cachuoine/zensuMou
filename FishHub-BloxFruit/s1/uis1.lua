local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StatsService = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local Player = Players.LocalPlayer
if not Player then
    Player = Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer
end
local PlayerGui = Player:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end
if PlayerGui:FindFirstChild("FishHub") then
    PlayerGui.FishHub:Destroy()
end
local SavedKey = ""
if readfile and isfile and isfile("FishHub_Key.json") then
    pcall(function()
        local data = HttpService:JSONDecode(readfile("FishHub_Key.json"))
        if data then
            SavedKey = data.key or ""
        end
    end)
end
local Config = {
    MainWidth = 700,
    MainHeight = 480,
    GUIAnimation = true,
    ToggleKey = Enum.KeyCode.K,
    ThemeColor = Color3.fromRGB(0, 229, 255),
    BgMain = Color3.fromRGB(45, 45, 52),
    BgCard = Color3.fromRGB(55, 55, 65),
    BorderColor = Color3.fromRGB(90, 90, 110),
    ShowDebug = true,
    UITransparency = 0.25,
    DebugTransparency = 0.25,
    RainbowSpeedPercent = 100,
}
local OpenGUI, CloseGUI, ToggleMain
local gui = Instance.new("ScreenGui")
gui.Name = "FishHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 1000
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = PlayerGui

-- Dedicated overlay so notifications are ALWAYS above the main FishHub UI.
local notificationGui = Instance.new("ScreenGui")
notificationGui.Name = "FishHub_Notifications"
notificationGui.ResetOnSpawn = false
notificationGui.IgnoreGuiInset = true
notificationGui.DisplayOrder = 2147483646
notificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
notificationGui.Parent = PlayerGui

local allHubStrokes = {}
local allHubLines = {}
local allThemeTexts = {}
local loadingScreen = Instance.new("Frame")
loadingScreen.Name = "AdvancedLoadingScreen"
loadingScreen.Parent = gui
loadingScreen.Size = UDim2.new(1, 0, 1, 0)
loadingScreen.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
loadingScreen.BackgroundTransparency = 1
loadingScreen.BorderSizePixel = 0
loadingScreen.Visible = false
loadingScreen.ZIndex = 999
local loadingGlow = Instance.new("Frame")
loadingGlow.Parent = loadingScreen
loadingGlow.Size = UDim2.new(0, 360, 0, 360)
loadingGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingGlow.AnchorPoint = Vector2.new(0.5, 0.5)
loadingGlow.BackgroundColor3 = Config.ThemeColor
loadingGlow.BackgroundTransparency = 0.94
loadingGlow.BorderSizePixel = 0
loadingGlow.ZIndex = 999
Instance.new("UICorner", loadingGlow).CornerRadius = UDim.new(1, 0)
local loadingCard = Instance.new("Frame")
loadingCard.Parent = loadingScreen
loadingCard.Size = UDim2.new(0, 360, 0, 190)
loadingCard.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingCard.AnchorPoint = Vector2.new(0.5, 0.5)
loadingCard.BackgroundColor3 = Color3.fromRGB(18, 19, 27)
loadingCard.BackgroundTransparency = 0.08
loadingCard.BorderSizePixel = 0
loadingCard.ZIndex = 1000
Instance.new("UICorner", loadingCard).CornerRadius = UDim.new(0, 16)
local loadingCardStroke = Instance.new("UIStroke")
loadingCardStroke.Parent = loadingCard
loadingCardStroke.Color = Config.ThemeColor
loadingCardStroke.Thickness = 1.5
loadingCardStroke.Transparency = 0.15
local loadingRing = Instance.new("Frame")
loadingRing.Parent = loadingCard
loadingRing.Size = UDim2.new(0, 54, 0, 54)
loadingRing.Position = UDim2.new(0.5, 0, 0, 24)
loadingRing.AnchorPoint = Vector2.new(0.5, 0)
loadingRing.BackgroundTransparency = 1
loadingRing.ZIndex = 1002
local ringOuter = Instance.new("Frame")
ringOuter.Parent = loadingRing
ringOuter.Size = UDim2.new(1, 0, 1, 0)
ringOuter.BackgroundTransparency = 1
ringOuter.BorderSizePixel = 0
ringOuter.ZIndex = 1002
Instance.new("UICorner", ringOuter).CornerRadius = UDim.new(1, 0)
local ringStroke = Instance.new("UIStroke")
ringStroke.Parent = ringOuter
ringStroke.Color = Config.ThemeColor
ringStroke.Thickness = 3
ringStroke.Transparency = 0.2
local ringInner = Instance.new("Frame")
ringInner.Parent = loadingRing
ringInner.Size = UDim2.new(0, 34, 0, 34)
ringInner.Position = UDim2.new(0.5, 0, 0.5, 0)
ringInner.AnchorPoint = Vector2.new(0.5, 0.5)
ringInner.BackgroundColor3 = Config.ThemeColor
ringInner.BackgroundTransparency = 0.88
ringInner.BorderSizePixel = 0
ringInner.ZIndex = 1003
Instance.new("UICorner", ringInner).CornerRadius = UDim.new(1, 0)
local ringDot = Instance.new("Frame")
ringDot.Parent = loadingRing
ringDot.Size = UDim2.new(0, 7, 0, 7)
ringDot.Position = UDim2.new(0.5, 0, 0.5, 0)
ringDot.AnchorPoint = Vector2.new(0.5, 0.5)
ringDot.BackgroundColor3 = Config.ThemeColor
ringDot.BorderSizePixel = 0
ringDot.ZIndex = 1004
Instance.new("UICorner", ringDot).CornerRadius = UDim.new(1, 0)
local loadingTitle = Instance.new("TextLabel")
loadingTitle.Parent = loadingCard
loadingTitle.Size = UDim2.new(1, -40, 0, 26)
loadingTitle.Position = UDim2.new(0.5, 0, 0, 84)
loadingTitle.AnchorPoint = Vector2.new(0.5, 0)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.TextSize = 17
loadingTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
loadingTitle.Text = "FISHHUB"
loadingTitle.TextTransparency = 1
loadingTitle.ZIndex = 1002
local loadingText = Instance.new("TextLabel")
loadingText.Parent = loadingCard
loadingText.Size = UDim2.new(1, -65, 0, 20)
loadingText.Position = UDim2.new(0.5, 0, 0, 111)
loadingText.AnchorPoint = Vector2.new(0.5, 0)
loadingText.BackgroundTransparency = 1
loadingText.Font = Enum.Font.GothamMedium
loadingText.TextSize = 11
loadingText.TextColor3 = Color3.fromRGB(175, 180, 195)
loadingText.Text = "Applying Theme & Reloading UI"
loadingText.TextTransparency = 1
loadingText.ZIndex = 1002
local loadingDots = Instance.new("TextLabel")
loadingDots.Parent = loadingCard
loadingDots.Size = UDim2.new(0, 25, 0, 20)
loadingDots.Position = UDim2.new(1, -42, 0, 111)
loadingDots.BackgroundTransparency = 1
loadingDots.Font = Enum.Font.GothamBold
loadingDots.TextSize = 11
loadingDots.TextColor3 = Config.ThemeColor
loadingDots.Text = ""
loadingDots.TextTransparency = 1
loadingDots.ZIndex = 1002
local progressBackground = Instance.new("Frame")
progressBackground.Parent = loadingCard
progressBackground.Size = UDim2.new(1, -50, 0, 4)
progressBackground.Position = UDim2.new(0.5, 0, 0, 146)
progressBackground.AnchorPoint = Vector2.new(0.5, 0)
progressBackground.BackgroundColor3 = Color3.fromRGB(45, 47, 58)
progressBackground.BackgroundTransparency = 0.2
progressBackground.BorderSizePixel = 0
progressBackground.ZIndex = 1002
Instance.new("UICorner", progressBackground).CornerRadius = UDim.new(1, 0)
local progressFill = Instance.new("Frame")
progressFill.Parent = progressBackground
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Config.ThemeColor
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 1003
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
local loadingStatus = Instance.new("TextLabel")
loadingStatus.Parent = loadingCard
loadingStatus.Size = UDim2.new(1, -40, 0, 18)
loadingStatus.Position = UDim2.new(0.5, 0, 0, 158)
loadingStatus.AnchorPoint = Vector2.new(0.5, 0)
loadingStatus.BackgroundTransparency = 1
loadingStatus.Font = Enum.Font.GothamMedium
loadingStatus.TextSize = 9
loadingStatus.TextColor3 = Color3.fromRGB(125, 130, 145)
loadingStatus.Text = "INITIALIZING"
loadingStatus.TextTransparency = 1
loadingStatus.ZIndex = 1002
local loadingAnimationRunning = false
local loadingAnimationToken = 0
local function UpdateLoadingTheme()
    local color = Config.ThemeColor
    loadingGlow.BackgroundColor3 = color
    loadingCardStroke.Color = color
    ringStroke.Color = color
    ringInner.BackgroundColor3 = color
    ringDot.BackgroundColor3 = color
    loadingDots.TextColor3 = color
    progressFill.BackgroundColor3 = color
end
local function StopLoadingAnimation()
    loadingAnimationRunning = false
    loadingAnimationToken += 1
end
local function StartLoadingAnimation()
    loadingAnimationToken += 1
    local token = loadingAnimationToken
    loadingAnimationRunning = true
    task.spawn(function()
        local dots = 0
        while loadingAnimationRunning and token == loadingAnimationToken and loadingScreen.Parent do
            dots = (dots + 1) % 4
            loadingDots.Text = string.rep(".", dots)
            loadingStatus.Text = ({"INITIALIZING", "APPLYING THEME", "UPDATING UI", "ALMOST READY"})[dots + 1]
            task.wait(0.22)
        end
    end)
    task.spawn(function()
        while loadingAnimationRunning and token == loadingAnimationToken and loadingScreen.Parent do
            loadingRing.Rotation = (loadingRing.Rotation + 8) % 360
            task.wait(0.025)
        end
    end)
    task.spawn(function()
        while loadingAnimationRunning and token == loadingAnimationToken and loadingScreen.Parent do
            local up = TweenService:Create(loadingGlow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 410, 0, 410), BackgroundTransparency = 0.965})
            local down = TweenService:Create(loadingGlow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 360, 0, 360), BackgroundTransparency = 0.94})
            up:Play()
            up.Completed:Wait()
            if not loadingAnimationRunning then break end
            down:Play()
            down.Completed:Wait()
        end
    end)
end
local themeLoadingActive = false
local themeLoadingState = {
    mainVisible = false,
    settingsVisible = false,
    openLineVisible = false,
    confirmVisible = false
}
local function GetThemeUI(name)
    return gui:FindFirstChild(name)
end
local THEME_LOADING_APPLY_DELAY = 2.15
local THEME_LOADING_FINISH_DELAY = 0.15
local function HideUIForThemeLoading()
    local mainUI = GetThemeUI("MainWindow")
    local settingsUI = GetThemeUI("SettingsWindow")
    local openLineUI = GetThemeUI("OpenLine")
    local confirmUI = GetThemeUI("ThemeConfirm")
    themeLoadingState.mainVisible = mainUI and mainUI.Visible or false
    themeLoadingState.settingsVisible = settingsUI and settingsUI.Visible or false
    themeLoadingState.openLineVisible = openLineUI and openLineUI.Visible or false
    themeLoadingState.confirmVisible = confirmUI and confirmUI.Visible or false
    if mainUI then mainUI.Visible = false end
    if settingsUI then settingsUI.Visible = false end
    if openLineUI then openLineUI.Visible = false end
    if confirmUI then confirmUI.Visible = false end
end
local function RestoreUIAfterThemeLoading()
    local mainUI = GetThemeUI("MainWindow")
    local settingsUI = GetThemeUI("SettingsWindow")
    local openLineUI = GetThemeUI("OpenLine")
    local confirmUI = GetThemeUI("ThemeConfirm")
    if mainUI then mainUI.Visible = themeLoadingState.mainVisible end
    if settingsUI then settingsUI.Visible = themeLoadingState.settingsVisible end
    if openLineUI then openLineUI.Visible = themeLoadingState.openLineVisible end
    if confirmUI then confirmUI.Visible = themeLoadingState.confirmVisible end
end
local function FinishAdvancedThemeLoading()
    if not loadingScreen.Parent then
        themeLoadingActive = false
        return
    end
    StopLoadingAnimation()
    TweenService:Create(
        progressFill,
        TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {Size = UDim2.new(1, 0, 1, 0)}
    ):Play()
    TweenService:Create(
        loadingCard,
        TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
        {
            Position = UDim2.new(0.5, 0, 0.5, -10),
            BackgroundTransparency = 1
        }
    ):Play()
    TweenService:Create(
        loadingGlow,
        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
        {
            Size = UDim2.new(0, 500, 0, 500),
            BackgroundTransparency = 1
        }
    ):Play()
    TweenService:Create(loadingTitle, TweenInfo.new(0.28), {TextTransparency = 1}):Play()
    TweenService:Create(loadingText, TweenInfo.new(0.28), {TextTransparency = 1}):Play()
    TweenService:Create(loadingDots, TweenInfo.new(0.28), {TextTransparency = 1}):Play()
    TweenService:Create(loadingStatus, TweenInfo.new(0.28), {TextTransparency = 1}):Play()
    local fade = TweenService:Create(
        loadingScreen,
        TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
        {BackgroundTransparency = 1}
    )
    fade:Play()
    task.delay(0.5, function()
        if not loadingScreen or not loadingScreen.Parent then
            themeLoadingActive = false
            RestoreUIAfterThemeLoading()
            return
        end
        loadingScreen.Visible = false
        progressFill.Size = UDim2.new(1, 0, 1, 0)
        loadingCard.BackgroundTransparency = 0.08
        loadingCard.Position = UDim2.new(0.5, 0, 0.5, 0)
        loadingTitle.TextTransparency = 1
        loadingText.TextTransparency = 1
        loadingDots.TextTransparency = 1
        loadingStatus.TextTransparency = 1
        task.defer(function()
            if loadingScreen.Visible == false then
                progressFill.Size = UDim2.new(0, 0, 1, 0)
            end
        end)
        loadingGlow.Size = UDim2.new(0, 280, 0, 280)
        loadingGlow.BackgroundTransparency = 1
        loadingRing.Size = UDim2.new(0, 42, 0, 42)
        loadingRing.Rotation = 0
        themeLoadingActive = false
        RestoreUIAfterThemeLoading()
    end)
    return
end
local function PlayAdvancedThemeLoading(targetColor, loadingTitleText, loadingSubtitleText)
    if themeLoadingActive then
        return false
    end
    themeLoadingActive = true
    Config.ThemeColor = targetColor
    UpdateLoadingTheme()
    HideUIForThemeLoading()
    StopLoadingAnimation()
    loadingScreen.Visible = true
    loadingScreen.BackgroundTransparency = 1
    loadingCard.Position = UDim2.new(0.5, 0, 0.5, 20)
    loadingCard.BackgroundTransparency = 1
    loadingTitle.Text = loadingTitleText or "FISHHUB"
    loadingText.Text = loadingSubtitleText or "Applying Theme & Reloading UI"
    loadingStatus.Text = "INITIALIZING"
    loadingTitle.TextTransparency = 1
    loadingText.TextTransparency = 1
    loadingDots.TextTransparency = 1
    loadingStatus.TextTransparency = 1
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    loadingGlow.Size = UDim2.new(0, 280, 0, 280)
    loadingGlow.BackgroundTransparency = 1
    loadingRing.Size = UDim2.new(0, 42, 0, 42)
    loadingRing.Rotation = 0
    StartLoadingAnimation()
    TweenService:Create(
        loadingScreen,
        TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.16}
    ):Play()
    TweenService:Create(
        loadingCard,
        TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 0.08
        }
    ):Play()
    TweenService:Create(
        loadingGlow,
        TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 360, 0, 360),
            BackgroundTransparency = 0.94
        }
    ):Play()
    TweenService:Create(
        loadingRing,
        TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 54, 0, 54)}
    ):Play()
    TweenService:Create(
        loadingTitle,
        TweenInfo.new(0.45),
        {TextTransparency = 0}
    ):Play()
    task.delay(0.18, function()
        if themeLoadingActive and loadingScreen.Parent then
            TweenService:Create(loadingText, TweenInfo.new(0.45), {TextTransparency = 0}):Play()
            TweenService:Create(loadingDots, TweenInfo.new(0.45), {TextTransparency = 0}):Play()
            TweenService:Create(loadingStatus, TweenInfo.new(0.45), {TextTransparency = 0}):Play()
        end
    end)
    TweenService:Create(progressFill, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.18, 0, 1, 0)}):Play()
    task.delay(0.45, function()
        if themeLoadingActive and loadingScreen.Parent then
            TweenService:Create(progressFill, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.42, 0, 1, 0)}):Play()
        end
    end)
    task.delay(0.9, function()
        if themeLoadingActive and loadingScreen.Parent then
            TweenService:Create(progressFill, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.68, 0, 1, 0)}):Play()
        end
    end)
    task.delay(1.45, function()
        if themeLoadingActive and loadingScreen.Parent then
            TweenService:Create(progressFill, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.88, 0, 1, 0)}):Play()
        end
    end)
    return true
end
UpdateLoadingTheme()
local notificationSerial = 0
local function ShowNotification(message)
    notificationSerial += 1
    local serial = notificationSerial

    local notifContainer = notificationGui:FindFirstChild("NotificationContainer")
    if not notifContainer then
        notifContainer = Instance.new("Frame")
        notifContainer.Name = "NotificationContainer"
        notifContainer.Parent = notificationGui
        notifContainer.Size = UDim2.new(0, 340, 0, 260)
        notifContainer.Position = UDim2.new(1, -18, 1, -18)
        notifContainer.AnchorPoint = Vector2.new(1, 1)
        notifContainer.BackgroundTransparency = 1
        notifContainer.BorderSizePixel = 0
        notifContainer.ZIndex = 10000

        local notifLayout = Instance.new("UIListLayout")
        notifLayout.Parent = notifContainer
        notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
        notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        notifLayout.Padding = UDim.new(0, 9)
    end

    local card = Instance.new("Frame")
    card.Name = "Notification"
    card.Parent = notifContainer
    card.Size = UDim2.new(0, 320, 0, 68)
    card.BackgroundColor3 = Color3.fromRGB(15, 17, 25)
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.LayoutOrder = serial
    card.ZIndex = 10001
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke")
    stroke.Parent = card
    stroke.Color = Config.ThemeColor
    stroke.Thickness = 1.4
    stroke.Transparency = 1
    table.insert(allHubStrokes, stroke)

    local glow = Instance.new("UIStroke")
    glow.Parent = card
    glow.Color = Config.ThemeColor
    glow.Thickness = 6
    glow.Transparency = 1

    local accent = Instance.new("Frame")
    accent.Parent = card
    accent.Size = UDim2.new(0, 3, 1, -18)
    accent.Position = UDim2.new(0, 8, 0, 9)
    accent.BackgroundColor3 = Config.ThemeColor
    accent.BackgroundTransparency = 1
    accent.BorderSizePixel = 0
    accent.ZIndex = 10002
    Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

    local icon = Instance.new("TextLabel")
    icon.Parent = card
    icon.Size = UDim2.new(0, 34, 0, 34)
    icon.Position = UDim2.new(0, 18, 0, 9)
    icon.BackgroundColor3 = Config.ThemeColor
    icon.BackgroundTransparency = 0.86
    icon.BorderSizePixel = 0
    icon.Font = Enum.Font.GothamBold
    icon.Text = "✓"
    icon.TextSize = 17
    icon.TextColor3 = Config.ThemeColor
    icon.TextTransparency = 1
    icon.ZIndex = 10003
    Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel")
    title.Parent = card
    title.Size = UDim2.new(1, -76, 0, 18)
    title.Position = UDim2.new(0, 62, 0, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextColor3 = Color3.fromRGB(245, 247, 255)
    title.Text = "FISHHUB  •  NOTIFICATION"
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTransparency = 1
    title.ZIndex = 10003

    local textLbl = Instance.new("TextLabel")
    textLbl.Parent = card
    textLbl.Size = UDim2.new(1, -76, 0, 27)
    textLbl.Position = UDim2.new(0, 62, 0, 28)
    textLbl.BackgroundTransparency = 1
    textLbl.Font = Enum.Font.GothamMedium
    textLbl.TextSize = 11
    textLbl.TextColor3 = Color3.fromRGB(180, 185, 200)
    textLbl.Text = tostring(message)
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.TextYAlignment = Enum.TextYAlignment.Center
    textLbl.TextWrapped = true
    textLbl.TextTransparency = 1
    textLbl.ZIndex = 10003

    local progressBarBg = Instance.new("Frame")
    progressBarBg.Parent = card
    progressBarBg.Size = UDim2.new(1, -20, 0, 3)
    progressBarBg.Position = UDim2.new(0, 10, 1, -8)
    progressBarBg.BackgroundColor3 = Color3.fromRGB(38, 40, 52)
    progressBarBg.BackgroundTransparency = 0.15
    progressBarBg.BorderSizePixel = 0
    progressBarBg.ZIndex = 10002
    Instance.new("UICorner", progressBarBg).CornerRadius = UDim.new(1, 0)

    local progressBar = Instance.new("Frame")
    progressBar.Parent = progressBarBg
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = Config.ThemeColor
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 10003
    Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1, 0)

    card.Position = UDim2.new(0, 36, 0, 0)

    TweenService:Create(card, TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0.08
    }):Play()
    TweenService:Create(stroke, TweenInfo.new(0.32), {Transparency = 0.08}):Play()
    TweenService:Create(glow, TweenInfo.new(0.32), {Transparency = 0.84}):Play()
    TweenService:Create(accent, TweenInfo.new(0.28), {BackgroundTransparency = 0}):Play()
    TweenService:Create(icon, TweenInfo.new(0.28), {TextTransparency = 0}):Play()
    TweenService:Create(title, TweenInfo.new(0.28), {TextTransparency = 0}):Play()
    TweenService:Create(textLbl, TweenInfo.new(0.35), {TextTransparency = 0}):Play()

    TweenService:Create(progressBar, TweenInfo.new(3.2, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()

    task.delay(3.2, function()
        if not card or not card.Parent then return end
        TweenService:Create(card, TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(0, 36, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(glow, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(accent, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        TweenService:Create(icon, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
        TweenService:Create(title, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
        TweenService:Create(textLbl, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
        task.wait(0.4)
        if card and card.Parent then card:Destroy() end
    end)
end

local openLine = Instance.new("Frame")
openLine.Name = "OpenLine"
openLine.Parent = gui
openLine.Size = UDim2.new(0,500,0,40)
openLine.Position = UDim2.new(0.5,0,0,8)
openLine.AnchorPoint = Vector2.new(0.5,0)
openLine.BackgroundColor3 = Color3.fromRGB(11,13,20)
openLine.BackgroundTransparency = 0.03
openLine.BorderSizePixel = 0
openLine.ZIndex = 900
Instance.new("UICorner",openLine).CornerRadius = UDim.new(1,0)
local openGradient = Instance.new("UIGradient")
openGradient.Parent = openLine
openGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(8,10,16)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(28,31,43)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(8,10,16))})
local openStroke = Instance.new("UIStroke")
openStroke.Parent = openLine
openStroke.Thickness = 1.5
openStroke.Color = Config.ThemeColor
openStroke.Transparency = 0.08
table.insert(allHubStrokes,openStroke)
local openGlow = Instance.new("UIStroke")
openGlow.Parent = openLine
openGlow.Thickness = 7
openGlow.Color = Config.ThemeColor
openGlow.Transparency = 0.86
table.insert(allHubStrokes,openGlow)
local openDot = Instance.new("Frame")
openDot.Parent = openLine
openDot.Size = UDim2.new(0,8,0,8)
openDot.Position = UDim2.new(0,18,0.5,0)
openDot.AnchorPoint = Vector2.new(0.5,0.5)
openDot.BackgroundColor3 = Config.ThemeColor
openDot.BorderSizePixel = 0
openDot.ZIndex = 902
Instance.new("UICorner",openDot).CornerRadius = UDim.new(1,0)
local openDotGlow = Instance.new("UIStroke")
openDotGlow.Parent = openDot
openDotGlow.Thickness = 3
openDotGlow.Color = Config.ThemeColor
openDotGlow.Transparency = 0.35
local openTitle = Instance.new("TextLabel")
openTitle.Parent = openLine
openTitle.Size = UDim2.new(0,190,1,0)
openTitle.Position = UDim2.new(0,34,0,0)
openTitle.BackgroundTransparency = 1
openTitle.Font = Enum.Font.GothamBold
openTitle.TextSize = 12
openTitle.TextColor3 = Color3.fromRGB(242,244,250)
openTitle.RichText = true
openTitle.Text = '<font color="#173B63">FISH</font><font color="#3B285E">HUB</font>'
openTitle.TextXAlignment = Enum.TextXAlignment.Left
openTitle.ZIndex = 902
local openSub = Instance.new("TextLabel")
openSub.Parent = openLine
openSub.Size = UDim2.new(0,90,1,0)
openSub.Position = UDim2.new(0,108,0,0)
openSub.BackgroundTransparency = 1
openSub.Font = Enum.Font.Code
openSub.TextSize = 8
openSub.TextColor3 = Color3.fromRGB(135,140,155)
openSub.Text = "CONTROL PANEL"
openSub.TextXAlignment = Enum.TextXAlignment.Left
openSub.ZIndex = 902
local openStatus = Instance.new("TextLabel")
openStatus.Parent = openLine
openStatus.Size = UDim2.new(0,65,1,0)
openStatus.Position = UDim2.new(1,-92,0,0)
openStatus.BackgroundTransparency = 1
openStatus.Font = Enum.Font.GothamBold
openStatus.TextSize = 9
openStatus.TextColor3 = Config.ThemeColor
openStatus.Text = "OPEN"
openStatus.TextXAlignment = Enum.TextXAlignment.Right
openStatus.ZIndex = 902
local sessionStartTime = os.clock()
local sessionTimer = Instance.new("TextLabel")
sessionTimer.Name = "SessionTimer"
sessionTimer.Parent = openLine
sessionTimer.Size = UDim2.new(0,82,1,0)
sessionTimer.Position = UDim2.new(1,-174,0,0)
sessionTimer.BackgroundTransparency = 1
sessionTimer.Font = Enum.Font.Code
sessionTimer.TextSize = 8
sessionTimer.TextColor3 = Color3.fromRGB(150,155,170)
sessionTimer.Text = "00:00:00"
sessionTimer.TextXAlignment = Enum.TextXAlignment.Right
sessionTimer.ZIndex = 902

local function FormatElapsedTime(seconds)
    seconds = math.max(0, math.floor(seconds))
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

task.spawn(function()
    while sessionTimer and sessionTimer.Parent and gui and gui.Parent do
        sessionTimer.Text = FormatElapsedTime(os.clock() - sessionStartTime)
        task.wait(0.25)
    end
end)

local openIcon = Instance.new("TextLabel")
openIcon.Parent = openLine
openIcon.Size = UDim2.new(0,18,1,0)
openIcon.Position = UDim2.new(1,-22,0,0)
openIcon.BackgroundTransparency = 1
openIcon.Font = Enum.Font.GothamBold
openIcon.TextSize = 15
openIcon.TextColor3 = Config.ThemeColor
openIcon.Text = "^"
openIcon.ZIndex = 902
local lineButton = Instance.new("TextButton")
lineButton.Parent = openLine
lineButton.Size = UDim2.fromScale(1,1)
lineButton.BackgroundTransparency = 1
lineButton.Text = ""
lineButton.AutoButtonColor = false
lineButton.ZIndex = 903
local openHover = false
lineButton.MouseEnter:Connect(function()
openHover=true
TweenService:Create(openLine,TweenInfo.new(0.18,Enum.EasingStyle.Quint),{Size=UDim2.new(0,520,0,42),BackgroundTransparency=0}):Play()
TweenService:Create(openGlow,TweenInfo.new(0.18),{Transparency=0.55}):Play()
TweenService:Create(openStroke,TweenInfo.new(0.18),{Transparency=0}):Play()
end)
lineButton.MouseLeave:Connect(function()
openHover=false
TweenService:Create(openLine,TweenInfo.new(0.18,Enum.EasingStyle.Quint),{Size=UDim2.new(0,500,0,40),BackgroundTransparency=0.03}):Play()
TweenService:Create(openGlow,TweenInfo.new(0.18),{Transparency=0.86}):Play()
TweenService:Create(openStroke,TweenInfo.new(0.18),{Transparency=0.08}):Play()
end)
lineButton.MouseButton1Click:Connect(function()
if ToggleMain then ToggleMain() end
end)
task.spawn(function()
local phase=0
while gui and gui.Parent do
phase=(phase+0.008)%1
openGradient.Offset=Vector2.new(phase*2-1,0)
if not openHover then
TweenService:Create(openDotGlow,TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=0.75}):Play()
task.wait(0.8)
TweenService:Create(openDotGlow,TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=0.3}):Play()
task.wait(0.8)
else
task.wait(0.08)
end
end
end)
local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Parent = gui
main.Size = UDim2.new(0, Config.MainWidth, 0, Config.MainHeight)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Config.BgMain
main.BackgroundTransparency = Config.UITransparency
main.BorderSizePixel = 0
main.Visible = false
local mainScale = Instance.new("UIScale")
mainScale.Parent = main
mainScale.Scale = 1
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
local mainStroke = Instance.new("UIStroke")
mainStroke.Parent = main
mainStroke.Thickness = 2
mainStroke.Color = Config.ThemeColor
local glowBorder = Instance.new("UIStroke")
glowBorder.Name = "GlowBorder"
glowBorder.Parent = main
glowBorder.Thickness = 4
glowBorder.Transparency = 0.4
glowBorder.Color = Config.ThemeColor
task.spawn(function()
    while main and main.Parent do
        TweenService:Create(glowBorder, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play()
        task.wait(1.2)
        TweenService:Create(glowBorder, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.6}):Play()
        task.wait(1.2)
    end
end)
-- Shared state used by the Main tab system.
-- These are NOT Settings/Gear state and therefore stay in Main.
local CONTENT_BORDER_COLOR = Color3.fromRGB(128, 128, 128)
local contentHoverRegistry = {}
local tabButtons = {}
local activeTabName = nil

-- Settings is lazy-loaded only when the Main Gear is clicked.
local SettingsController = nil
local SettingsLoadAttempted = false
local SETTINGS_URL = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/gear.lua"
local debugSidebarFrame = Instance.new("Frame")
debugSidebarFrame.Name = "DebugSidebar"
debugSidebarFrame.Parent = gui
debugSidebarFrame.Size = UDim2.new(0, 180, 0, 76)
debugSidebarFrame.Position = UDim2.new(1, -190, 1, -138)
debugSidebarFrame.BackgroundColor3 = Config.BgCard
debugSidebarFrame.BackgroundTransparency = Config.DebugTransparency
debugSidebarFrame.BorderSizePixel = 0
debugSidebarFrame.Visible = Config.ShowDebug
Instance.new("UICorner", debugSidebarFrame).CornerRadius = UDim.new(0, 8)
local debugSidebarStroke = Instance.new("UIStroke")
debugSidebarStroke.Parent = debugSidebarFrame
debugSidebarStroke.Thickness = 1
debugSidebarStroke.Color = Config.ThemeColor
table.insert(allHubStrokes, debugSidebarStroke)
local debugSidebarText = Instance.new("TextLabel")
debugSidebarText.Parent = debugSidebarFrame
debugSidebarText.Size = UDim2.new(1, -12, 0, 70)
debugSidebarText.Position = UDim2.new(0, 6, 0, 3)
debugSidebarText.TextWrapped = false
debugSidebarText.BackgroundTransparency = 1
debugSidebarText.Font = Enum.Font.Code
debugSidebarText.TextSize = 10
debugSidebarText.TextColor3 = Color3.fromRGB(240, 240, 240)
debugSidebarText.TextXAlignment = Enum.TextXAlignment.Left
debugSidebarText.TextYAlignment = Enum.TextYAlignment.Top
debugSidebarText.RichText = true
local keyStatusSidebarFrame = Instance.new("Frame")
keyStatusSidebarFrame.Name = "KeyStatusSidebar"
keyStatusSidebarFrame.Parent = gui
keyStatusSidebarFrame.Size = UDim2.new(0, 180, 0, 56)
keyStatusSidebarFrame.Position = UDim2.new(1, -190, 1, -56)
keyStatusSidebarFrame.BackgroundColor3 = Config.BgCard
keyStatusSidebarFrame.BackgroundTransparency = Config.DebugTransparency
keyStatusSidebarFrame.BorderSizePixel = 0
keyStatusSidebarFrame.Visible = Config.ShowDebug
Instance.new("UICorner", keyStatusSidebarFrame).CornerRadius = UDim.new(0, 8)
local keyStatusStroke = Instance.new("UIStroke")
keyStatusStroke.Parent = keyStatusSidebarFrame
keyStatusStroke.Thickness = 1
keyStatusStroke.Color = Config.ThemeColor
table.insert(allHubStrokes, keyStatusStroke)
local debugDividerBetween = Instance.new("Frame")
debugDividerBetween.Parent = gui
debugDividerBetween.Size = UDim2.new(0, 180, 0, 2)
debugDividerBetween.Position = UDim2.new(1, -190, 1, -60)
debugDividerBetween.BackgroundColor3 = Config.ThemeColor
debugDividerBetween.BackgroundTransparency = 0.2
debugDividerBetween.BorderSizePixel = 0
debugDividerBetween.Visible = Config.ShowDebug
Instance.new("UICorner", debugDividerBetween).CornerRadius = UDim.new(1, 0)
table.insert(allHubLines, debugDividerBetween)
local currentTween = nil
local isMainOpen = false
local toggleSerial = 0
local lastToggleAt = 0
local TOGGLE_DEBOUNCE = 0.12

local function SyncToplineState()
    if not openStatus or not openIcon then
        return
    end

    if isMainOpen then
        openStatus.Text = "OPEN"
        openIcon.Text = "^"
    else
        openStatus.Text = "CLOSED"
        openIcon.Text = "v"
    end
end

OpenGUI = function()
    toggleSerial = toggleSerial + 1
    local mySerial = toggleSerial
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    isMainOpen = true
    SyncToplineState()
    local selectedScale = 1.0
    main.Visible = true
    if SettingsController then SettingsController:Close() end
    if not Config.GUIAnimation then
        mainScale.Scale = selectedScale
        main.BackgroundTransparency = Config.UITransparency
        return
    end
    mainScale.Scale = selectedScale * 0.85
    main.BackgroundTransparency = 1
    local fadeTween = TweenService:Create(
        main,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {BackgroundTransparency = Config.UITransparency}
    )
    local scaleTween = TweenService:Create(
        mainScale,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Scale = selectedScale}
    )
    currentTween = fadeTween
    fadeTween:Play()
    scaleTween:Play()
    task.spawn(function()
        fadeTween.Completed:Wait()
        if mySerial ~= toggleSerial or not isMainOpen then
            return
        end
        currentTween = nil
        main.Visible = true
        mainScale.Scale = selectedScale
    end)
end
CloseGUI = function()
    toggleSerial = toggleSerial + 1
    local mySerial = toggleSerial
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    isMainOpen = false
    SyncToplineState()
    if SettingsController then SettingsController:Close() end
    local selectedScale = 1.0
    if not Config.GUIAnimation then
        main.Visible = false
        mainScale.Scale = selectedScale
        return
    end
    local fadeTween = TweenService:Create(
        main,
        TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {BackgroundTransparency = 1}
    )
    local scaleTween = TweenService:Create(
        mainScale,
        TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {Scale = selectedScale * 0.85}
    )
    currentTween = fadeTween
    fadeTween:Play()
    scaleTween:Play()
    task.spawn(function()
        fadeTween.Completed:Wait()
        if mySerial ~= toggleSerial or isMainOpen then
            return
        end
        main.Visible = false
        mainScale.Scale = selectedScale
        currentTween = nil
    end)
end
ToggleMain = function()
local now=os.clock()
if now-lastToggleAt<TOGGLE_DEBOUNCE then return end
lastToggleAt=now
if isMainOpen then
    CloseGUI()
else
    OpenGUI()
end
SyncToplineState()
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then
        return
    end
    if SettingsController
        and SettingsController.IsListeningKey
        and SettingsController.IsListeningKey() then
        return
    end
    if input.KeyCode == Config.ToggleKey then
        ToggleMain()
    end
end)
local header = Instance.new("Frame")
header.Parent = main
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundTransparency = 1
header.ClipsDescendants = true
local middleSeparator = Instance.new("TextLabel")
middleSeparator.Parent = header
middleSeparator.BackgroundTransparency = 1
middleSeparator.Size = UDim2.new(0, 50, 1, 0)
middleSeparator.Position = UDim2.new(0.5, -25, 0, 0)
middleSeparator.RichText = true
middleSeparator.Text = "<font color='#808090'>┆</font>"
middleSeparator.Font = Enum.Font.GothamBold
middleSeparator.TextSize = 18
middleSeparator.TextColor3 = Color3.fromRGB(255, 255, 255)
middleSeparator.TextXAlignment = Enum.TextXAlignment.Center
local leftTitle = Instance.new("TextLabel")
leftTitle.Parent = header
leftTitle.BackgroundTransparency = 1
leftTitle.Size = UDim2.new(0.5, -15, 1, 0)
leftTitle.RichText = true
leftTitle.Text = "⚓ <font color='#00E5FF'>FishHub</font>"
leftTitle.Font = Enum.Font.GothamBold
leftTitle.TextSize = 18
leftTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
leftTitle.TextXAlignment = Enum.TextXAlignment.Right
local gameName = "Roblox Game"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then
        gameName = info.Name
    end
end)
local rightTitle = Instance.new("TextLabel")
rightTitle.Parent = header
rightTitle.BackgroundTransparency = 1
rightTitle.Size = UDim2.new(0.5, -15, 1, 0)
rightTitle.RichText = true
rightTitle.Text = "<font color='#A855F7'>" .. gameName .. "</font>"
rightTitle.Font = Enum.Font.GothamBold
rightTitle.TextSize = 18
rightTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
rightTitle.TextXAlignment = Enum.TextXAlignment.Left
task.spawn(function()
    while header and header.Parent do
        leftTitle.Position = UDim2.new(0, -400, 0, 0)
        rightTitle.Position = UDim2.new(0.5, 400, 0, 0)
        local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local t1 = TweenService:Create(leftTitle, tweenInfo, {Position = UDim2.new(0, 0, 0, 0)})
        local t2 = TweenService:Create(rightTitle, tweenInfo, {Position = UDim2.new(0.5, 15, 0, 0)})
        t1:Play()
        t2:Play()
        task.wait(2.5)
    end
end)
local line = Instance.new("Frame")
line.Parent = main
line.Size = UDim2.new(1, -20, 0, 1)
line.Position = UDim2.new(0, 10, 0, 45)
line.BackgroundColor3 = Config.ThemeColor
line.BorderSizePixel = 0
table.insert(allHubLines, line)
local rightBottomStatus = Instance.new("TextLabel")
rightBottomStatus.Parent = main
rightBottomStatus.Size = UDim2.new(0, 200, 0, 20)
rightBottomStatus.Position = UDim2.new(1, -12, 1, -9)
rightBottomStatus.AnchorPoint = Vector2.new(1, 1)
rightBottomStatus.BackgroundTransparency = 1
rightBottomStatus.RichText = true
rightBottomStatus.Font = Enum.Font.GothamBold
rightBottomStatus.TextSize = 10
rightBottomStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
rightBottomStatus.TextXAlignment = Enum.TextXAlignment.Right
rightBottomStatus.TextYAlignment = Enum.TextYAlignment.Bottom
task.spawn(function()
    while rightBottomStatus and rightBottomStatus.Parent do
        rightBottomStatus.Text = "<font color='#00FF00'>•</font> Status: working | <font color='#A855F7'>•</font> Version: v1"
        task.wait(0.6)
        rightBottomStatus.Text = "<font color='#006600'>•</font> Status: working | <font color='#581C87'>•</font> Version: v1"
        task.wait(0.6)
    end
end)
local joinDiscordBtn = Instance.new("TextButton")
joinDiscordBtn.Parent = main
joinDiscordBtn.Size = UDim2.new(0, 140, 0, 24)
joinDiscordBtn.Position = UDim2.new(0, 12, 1, -3)
joinDiscordBtn.AnchorPoint = Vector2.new(0, 1)
joinDiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
joinDiscordBtn.BorderSizePixel = 0
joinDiscordBtn.AutoButtonColor = false
joinDiscordBtn.Font = Enum.Font.GothamBold
joinDiscordBtn.TextSize = 11
joinDiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
joinDiscordBtn.Text = "💬 Join Discord"
Instance.new("UICorner", joinDiscordBtn).CornerRadius = UDim.new(0, 6)
local joinDiscordStroke = Instance.new("UIStroke")
joinDiscordStroke.Parent = joinDiscordBtn
joinDiscordStroke.Color = Config.ThemeColor
joinDiscordStroke.Thickness = 1
table.insert(allHubStrokes, joinDiscordStroke)
local function GetCurrentAccentColor()
    if SettingsController and SettingsController.GetCurrentAccentColor then
        return SettingsController.GetCurrentAccentColor()
    end
    return Config.ThemeColor
end
local function CreateCursorGlow(parent)
    local glow = Instance.new("Frame")
    glow.Name = "CursorSoftGlow"
    glow.Parent = parent
    glow.Size = UDim2.new(0, 86, 0, 86)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.BackgroundColor3 = Config.ThemeColor
    glow.BackgroundTransparency = 0.93
    glow.BorderSizePixel = 0
    glow.Active = false
    glow.Visible = false
    glow.ZIndex = math.max(0, parent.ZIndex - 1)
    local corner = Instance.new("UICorner")
    corner.Parent = glow
    corner.CornerRadius = UDim.new(0, 24)
    local gradient = Instance.new("UIGradient")
    gradient.Parent = glow
    gradient.Rotation = 45
    gradient.Color = ColorSequence.new(Color3.new(1, 1, 1))
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.18, 0.98),
        NumberSequenceKeypoint.new(0.5, 0.72),
        NumberSequenceKeypoint.new(0.82, 0.98),
        NumberSequenceKeypoint.new(1, 1)
    })
    return glow
end
local function AddHoverGlow(card, stroke)
    if not card or not stroke then return end
    card.ClipsDescendants = true
    stroke.Color = CONTENT_BORDER_COLOR
    local state = {
        hovered = false,
        stroke = stroke,
        card = card,
        glow = CreateCursorGlow(card)
    }
    contentHoverRegistry[stroke] = state
    local function UpdateGlow(x, y)
        if not card.Parent then return end
        local accent = GetCurrentAccentColor()
        stroke.Color = accent
        state.glow.BackgroundColor3 = accent
        local localX = math.clamp(
            x or card.AbsoluteSize.X * 0.5,
            0,
            card.AbsoluteSize.X
        )
        local localY = math.clamp(
            y or card.AbsoluteSize.Y * 0.5,
            0,
            card.AbsoluteSize.Y
        )
        state.glow.Position = UDim2.fromOffset(localX, localY)
        state.glow.Visible = true
    end
    card.MouseEnter:Connect(function(x, y)
        state.hovered = true
        UpdateGlow(x, y)
    end)
    card.MouseMoved:Connect(function(x, y)
        if state.hovered then
            UpdateGlow(x, y)
        end
    end)
    card.MouseLeave:Connect(function()
        state.hovered = false
        state.glow.Visible = false
        stroke.Color = CONTENT_BORDER_COLOR
    end)
end
AddHoverGlow(joinDiscordBtn, joinDiscordStroke)
joinDiscordBtn.MouseButton1Click:Connect(function()
    local discordUrl = "https://discord.gg/zFN6Nd99fC"
    pcall(function()
        if setclipboard then
            setclipboard(discordUrl)
        end
    end)
    ShowNotification("Successfully copied Discord link!")
end)
local navContainer = Instance.new("Frame")
navContainer.Parent = main
navContainer.Size = UDim2.new(0, 320, 0, 32)
navContainer.Position = UDim2.new(0.5, 0, 0, 52)
navContainer.AnchorPoint = Vector2.new(0.5, 0)
navContainer.BackgroundTransparency = 1
local navLayout = Instance.new("UIListLayout")
navLayout.Parent = navContainer
navLayout.FillDirection = Enum.FillDirection.Horizontal
navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
navLayout.VerticalAlignment = Enum.VerticalAlignment.Center
navLayout.Padding = UDim.new(0, 10)
local contentContainer = Instance.new("Frame")
contentContainer.Parent = main
contentContainer.Size = UDim2.new(1, -20, 1, -120)
contentContainer.Position = UDim2.new(0, 10, 0, 90)
contentContainer.BackgroundTransparency = 1
local tabs = {}
local function CreateTabContent(name)
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = name .. "Tab"
    tabFrame.Parent = contentContainer
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.Visible = false
    tabFrame.ScrollBarThickness = 0
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabs[name] = tabFrame
    return tabFrame
end
CreateTabContent("Home")
CreateTabContent("Function")
CreateTabContent("Creative")

-- URL Mapping cho từng Tab (Bạn có thể thay thế các URL bên dưới bằng link script thực tế của bạn)
local TabUrls = {
    Home = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/home.lua",
    Function = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/function.lua",
    Creative = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/creative.lua"
}

local loadedTabs = {}
local loadingTabs = {}

local function LoadTabUrl(tabName)
    if loadedTabs[tabName] or loadingTabs[tabName] then
        return loadedTabs[tabName] == true
    end

    local url = TabUrls[tabName]
    if type(url) ~= "string" or url == "" then
        warn("[FishHub] Missing URL for tab: " .. tostring(tabName))
        return false
    end

    loadingTabs[tabName] = true
    local ok, err = pcall(function()
        local source = game:HttpGet(url)
        if type(source) ~= "string" or #source < 10 then
            error("Remote script returned empty/invalid source")
        end

        local chunk, compileError = loadstring(source)
        if type(chunk) ~= "function" then
            error("Compile error: " .. tostring(compileError))
        end

        -- home.lua / function.lua / creative.lua use `local context = ...`.
        -- Pass the REAL FishHub objects into the remote chunk so the scripts
        -- build their UI inside the existing tab instead of creating/finding
        -- another GUI. This is the important part.
        local context = {
            Player = Players.LocalPlayer,
            PlayerGui = Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"),
            Tab = tabs[tabName],
            MainWindow = main,
            Main = main,
            Gui = gui,
            Config = Config,
            Players = Players,
            TweenService = TweenService,
            UserInputService = UserInputService,
            HttpService = HttpService,
            ShowNotification = ShowNotification,
            TabName = tabName
        }

        -- Execute with the context as vararg. The current GitHub tab files
        -- consume this through `local context = ...`.
        local result = chunk(context)

        -- Also support module-style files that return a function.
        if type(result) == "function" then
            local moduleOk, moduleErr = pcall(result, context)
            if not moduleOk then
                error(moduleErr)
            end
        end

        loadedTabs[tabName] = true
    end)

    loadingTabs[tabName] = nil

    if not ok then
        warn("[FishHub] " .. tabName .. " failed to load: " .. tostring(err))
        ShowNotification(tabName .. " failed to load: " .. tostring(err))
        loadedTabs[tabName] = nil
        return false
    end

    return true
end

local tabTransitionId = 0
local function AnimateTabButton(btn, tabName, selected)
    if not btn or not btn.Parent then return end
    local glow = btn:FindFirstChild("TabGlow")
    local scale = btn:FindFirstChild("TabScale")
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    if not glow or not scale then return end

    local accent = GetCurrentAccentColor and GetCurrentAccentColor() or Config.ThemeColor
    glow.BackgroundColor3 = accent
    if stroke then
        stroke.Color = accent
    end

    if selected then
        TweenService:Create(scale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1.055
        }):Play()
        TweenService:Create(glow, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 18, 1, 14),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 0.88
        }):Play()
        task.delay(0.16, function()
            if not btn.Parent then return end
            TweenService:Create(glow, TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 7, 1, 5),
                BackgroundTransparency = 0.94
            }):Play()
        end)
    else
        TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
        TweenService:Create(glow, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1
        }):Play()
    end
end

local function SwitchTab(tabName)
    if not tabs[tabName] then return end
    if activeTabName == tabName then
        AnimateTabButton(tabButtons[tabName], tabName, true)
        return
    end

    tabTransitionId += 1
    local transitionId = tabTransitionId
    local previousTab = activeTabName
    activeTabName = tabName

    if tabButtons[previousTab] then
        AnimateTabButton(tabButtons[previousTab], previousTab, false)
    end

    for name, frame in pairs(tabs) do
        if name == tabName then
            frame.Visible = true
            frame.Position = UDim2.new(0, 24, 0, 6)
            frame.BackgroundTransparency = 1
            TweenService:Create(frame, TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1
            }):Play()
        else
            frame.Visible = false
        end
    end

    for name, btn in pairs(tabButtons) do
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        local targetActive = name == tabName
        TweenService:Create(btn, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            BackgroundColor3 = targetActive and Config.ThemeColor or Color3.fromRGB(55, 55, 65),
            TextColor3 = targetActive and Color3.fromRGB(20, 22, 30) or Color3.fromRGB(230, 230, 240),
            Size = targetActive and UDim2.new(0, 100, 0, 30) or UDim2.new(0, 95, 0, 28)
        }):Play()
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Color = Config.ThemeColor,
                Thickness = targetActive and 2 or 1,
                Transparency = targetActive and 0 or 0.25
            }):Play()
        end
        AnimateTabButton(btn, name, targetActive)
    end

    task.delay(0.04, function()
        if transitionId ~= tabTransitionId then return end
        local btn = tabButtons[tabName]
        if btn then
            AnimateTabButton(btn, tabName, true)
        end
    end)

    -- Tải nội dung script qua URL tương ứng khi ấn vào tab
    task.spawn(function()
        LoadTabUrl(tabName)
    end)
end

local function CreateNavButton(name)
    local btn = Instance.new("TextButton")
    btn.Parent = navContainer
    btn.Size = UDim2.new(0, 95, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(230, 230, 240)
    btn.ZIndex = 6
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    local btnScale = Instance.new("UIScale")
    btnScale.Name = "TabScale"
    btnScale.Scale = 1
    btnScale.Parent = btn

    local glow = Instance.new("Frame")
    glow.Name = "TabGlow"
    glow.Parent = btn
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.Size = UDim2.new(1, 0, 1, 0)
    glow.BackgroundColor3 = Config.ThemeColor
    glow.BackgroundTransparency = 1
    glow.BorderSizePixel = 0
    glow.ZIndex = btn.ZIndex - 1
    Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 9)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Parent = btn
    btnStroke.Color = Config.ThemeColor
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.25
    table.insert(allHubStrokes, btnStroke)

    btn.MouseEnter:Connect(function()
        local accent = GetCurrentAccentColor and GetCurrentAccentColor() or Config.ThemeColor
        glow.BackgroundColor3 = accent
        TweenService:Create(glow, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 8, 1, 6),
            BackgroundTransparency = activeTabName == name and 0.9 or 0.95
        }):Play()
        if activeTabName ~= name then
            TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(68, 70, 82),
                Size = UDim2.new(0, 98, 0, 29)
            }):Play()
            TweenService:Create(btnScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1.025
            }):Play()
        end
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(glow, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = activeTabName == name and 0.94 or 1
        }):Play()
        if activeTabName ~= name then
            TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(55, 55, 65),
                Size = UDim2.new(0, 95, 0, 28)
            }):Play()
            TweenService:Create(btnScale, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play()
        else
            TweenService:Create(btnScale, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Scale = 1.055
            }):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
    tabButtons[name] = btn
end
CreateNavButton("Home")
CreateNavButton("Function")
CreateNavButton("Creative")
local runningLineContainer = Instance.new("Frame")
runningLineContainer.Parent = main
runningLineContainer.Size = UDim2.new(1, 0, 0, 32)
runningLineContainer.Position = UDim2.new(0, 0, 0, 52)
runningLineContainer.BackgroundTransparency = 1
runningLineContainer.ZIndex = 5
local exactSideWidth = 180
local exactMaxChars = 27
local leftRunningLabel = Instance.new("TextLabel")
leftRunningLabel.Parent = runningLineContainer
leftRunningLabel.Size = UDim2.new(0, exactSideWidth, 1, 0)
leftRunningLabel.Position = UDim2.new(0, 10, 0, 0)
leftRunningLabel.BackgroundTransparency = 1
leftRunningLabel.Font = Enum.Font.Code
leftRunningLabel.TextSize = 13
leftRunningLabel.TextColor3 = Config.ThemeColor
leftRunningLabel.TextXAlignment = Enum.TextXAlignment.Right
leftRunningLabel.ClipsDescendants = true
leftRunningLabel.ZIndex = 5
table.insert(allThemeTexts, leftRunningLabel)
local rightRunningLabel = Instance.new("TextLabel")
rightRunningLabel.Parent = runningLineContainer
rightRunningLabel.Size = UDim2.new(0, exactSideWidth, 1, 0)
rightRunningLabel.Position = UDim2.new(1, -exactSideWidth - 10, 0, 0)
rightRunningLabel.BackgroundTransparency = 1
rightRunningLabel.Font = Enum.Font.Code
rightRunningLabel.TextSize = 13
rightRunningLabel.TextColor3 = Config.ThemeColor
rightRunningLabel.TextXAlignment = Enum.TextXAlignment.Left
rightRunningLabel.ClipsDescendants = true
rightRunningLabel.ZIndex = 5
table.insert(allThemeTexts, rightRunningLabel)
task.spawn(function()
    while runningLineContainer and runningLineContainer.Parent do
        for i = 0, exactMaxChars do
            if not (runningLineContainer and runningLineContainer.Parent) then break end
            leftRunningLabel.Text = string.rep("=", i) .. ">"
            rightRunningLabel.Text = "<" .. string.rep("=", i)
            task.wait(0.06)
        end
    end
end)
SwitchTab("Home")
local keyStatusTitle = Instance.new("TextLabel")
keyStatusTitle.Parent = keyStatusSidebarFrame
keyStatusTitle.Size = UDim2.new(1, -12, 0, 16)
keyStatusTitle.Position = UDim2.new(0, 6, 0, 4)
keyStatusTitle.BackgroundTransparency = 1
keyStatusTitle.Font = Enum.Font.GothamBold
keyStatusTitle.TextSize = 9.5
keyStatusTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
keyStatusTitle.Text = "KEY STATUS"
keyStatusTitle.TextXAlignment = Enum.TextXAlignment.Left
local keyInnerCard = Instance.new("Frame")
keyInnerCard.Parent = keyStatusSidebarFrame
keyInnerCard.Size = UDim2.new(1, -12, 0, 26)
keyInnerCard.Position = UDim2.new(0, 6, 0, 26)
keyInnerCard.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
keyInnerCard.BorderSizePixel = 0
Instance.new("UICorner", keyInnerCard).CornerRadius = UDim.new(0, 6)
local greenDotKey = Instance.new("Frame")
greenDotKey.Parent = keyInnerCard
greenDotKey.Size = UDim2.new(0, 8, 0, 8)
greenDotKey.Position = UDim2.new(0, 8, 0.5, -4)
greenDotKey.BackgroundColor3 = Color3.fromRGB(50, 230, 80)
greenDotKey.BorderSizePixel = 0
Instance.new("UICorner", greenDotKey).CornerRadius = UDim.new(1, 0)
task.spawn(function()
    while greenDotKey and greenDotKey.Parent do
        TweenService:Create(greenDotKey, TweenInfo.new(0.6), {BackgroundTransparency = 0.2}):Play()
        task.wait(0.6)
        TweenService:Create(greenDotKey, TweenInfo.new(0.6), {BackgroundTransparency = 0.8}):Play()
        task.wait(0.6)
    end
end)
local keyNameLabel = Instance.new("TextLabel")
keyNameLabel.Parent = keyInnerCard
keyNameLabel.Size = UDim2.new(0, 75, 1, 0)
keyNameLabel.Position = UDim2.new(0, 22, 0, 0)
keyNameLabel.BackgroundTransparency = 1
keyNameLabel.Font = Enum.Font.GothamBold
keyNameLabel.TextSize = 10
keyNameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
keyNameLabel.Text = "K"
keyNameLabel.TextXAlignment = Enum.TextXAlignment.Left
local keyActiveLabel = Instance.new("TextLabel")
keyActiveLabel.Parent = keyInnerCard
keyActiveLabel.Size = UDim2.new(1, -95, 1, 0)
keyActiveLabel.Position = UDim2.new(0, 92, 0, 0)
keyActiveLabel.BackgroundTransparency = 1
keyActiveLabel.Font = Enum.Font.GothamBold
keyActiveLabel.TextSize = 9.5
keyActiveLabel.TextColor3 = Color3.fromRGB(50, 230, 80)
keyActiveLabel.Text = "LOADING..."
keyActiveLabel.TextXAlignment = Enum.TextXAlignment.Right
task.spawn(function()
    if SavedKey == "DHLADMIN22052009" then
        keyActiveLabel.Text = "LIFETIME"
        keyActiveLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    elseif SavedKey ~= "" then
        local FIREBASE_URL = "https://fishhub-35d18-default-rtdb.firebaseio.com/keys"
        local url = FIREBASE_URL .. "/" .. SavedKey .. ".json"
        local success, response = pcall(function() return game:HttpGet(url) end)
        local keyData = nil
        if success and response and response ~= "null" then
            keyData = HttpService:JSONDecode(response)
        else
            local fallbackSuccess, fallbackResponse = pcall(function()
                return game:HttpGet(FIREBASE_URL .. ".json")
            end)
            if fallbackSuccess and fallbackResponse and fallbackResponse ~= "null" then
                local decoded = HttpService:JSONDecode(fallbackResponse)
                if type(decoded) == "table" then
                    for k, v in pairs(decoded) do
                        if k == SavedKey or v == SavedKey or (type(v) == "table" and (v.key == SavedKey or v.Key == SavedKey)) then
                            keyData = v
                            break
                        end
                    end
                end
            end
        end
        if type(keyData) == "table" and keyData.createdAt then
            local createdAtSec = math.floor(tonumber(keyData.createdAt) / 1000)
            local expireTime = createdAtSec + 86400
            while gui and gui.Parent do
                local currentTime = os.time()
                local timeRemaining = expireTime - currentTime
                if timeRemaining > 0 then
                    local h = math.floor(timeRemaining / 3600)
                    local m = math.floor((timeRemaining % 3600) / 60)
                    local s = timeRemaining % 60
                    keyActiveLabel.Text = string.format("%02d:%02d:%02d", h, m, s)
                    keyActiveLabel.TextColor3 = Color3.fromRGB(50, 230, 80)
                else
                    keyActiveLabel.Text = "EXPIRED!"
                    keyActiveLabel.TextColor3 = Color3.fromRGB(230, 50, 50)
                    break
                end
                task.wait(1)
            end
        else
            keyActiveLabel.Text = "NO KEY"
            keyActiveLabel.TextColor3 = Color3.fromRGB(230, 50, 50)
        end
    else
        keyActiveLabel.Text = "NO KEY"
        keyActiveLabel.TextColor3 = Color3.fromRGB(230, 50, 50)
    end
end)
task.spawn(function()
    while gui and gui.Parent do
        if Config.ToggleKey then
            keyNameLabel.Text = Config.ToggleKey.Name
        end
        task.wait(1)
    end
end)
local frameCount = 0
local lastFpsUpdate = os.clock()
local currentFps = 60
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = os.clock()
    if now - lastFpsUpdate >= 1 then
        currentFps = math.floor(frameCount / (now - lastFpsUpdate))
        frameCount = 0
        lastFpsUpdate = now
    end
end)
task.spawn(function()
    while gui and gui.Parent do
        if Config.ShowDebug then
            local ping = 0
            pcall(function()
                ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            local memoryUsage = 0
            pcall(function()
                memoryUsage = math.floor(StatsService:GetTotalMemoryUsageMb())
            end)
            local time24h = os.date("%H:%M:%S")
            local playerCount = #Players:GetPlayers()
            local maxPlayers = Players.MaxPlayers
            debugSidebarText.Text = string.format(
                "⚡ <b>FPS:</b> %d\n" ..
                "📶 <b>PING:</b> %dms\n" ..
                "💾 <b>MEM:</b> %dMB\n" ..
                "👥 <b>PLAYERS:</b> <font color='#FFDF00'>%d/%d</font>\n" ..
                "🕒 <b>TIME:</b> %s",
                currentFps, ping, memoryUsage, playerCount, maxPlayers, time24h
            )
        end
        task.wait(0.5)
    end
end)
local function CreateCircleButton(text, xOffset)
    local btn = Instance.new("TextButton")
    btn.Parent = main
    btn.Size = UDim2.new(0, 26, 0, 26)
    btn.AnchorPoint = Vector2.new(1, 0)
    btn.Position = UDim2.new(1, -xOffset, 0, 8)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(230, 230, 240)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Parent = btn
    btnStroke.Color = Config.ThemeColor
    btnStroke.Thickness = 1
    table.insert(allHubStrokes, btnStroke)
    AddHoverGlow(btn, btnStroke)
    return btn
end
local closeBtn = CreateCircleButton("×", 12)
local hideBtn  = CreateCircleButton("─", 44)
local gearBtn  = CreateCircleButton("⚙", 76)
local confirm = Instance.new("Frame")
confirm.Name = "ThemeConfirm"
confirm.Parent = gui
confirm.Size = UDim2.new(0, 300, 0, 130)
confirm.Position = UDim2.new(0.5, 0, 0.5, 0)
confirm.AnchorPoint = Vector2.new(0.5, 0.5)
confirm.BackgroundColor3 = Config.BgMain
confirm.Visible = false
confirm.BorderSizePixel = 0
Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 10)
local confirmStroke = Instance.new("UIStroke")
confirmStroke.Parent = confirm
confirmStroke.Color = Config.ThemeColor
confirmStroke.Thickness = 1
table.insert(allHubStrokes, confirmStroke)
AddHoverGlow(confirm, confirmStroke)
local txt = Instance.new("TextLabel")
txt.Parent = confirm
txt.Size = UDim2.new(1, -20, 0, 40)
txt.Position = UDim2.new(0, 10, 0, 25)
txt.BackgroundTransparency = 1
txt.Font = Enum.Font.GothamBold
txt.TextSize = 13
txt.TextColor3 = Color3.fromRGB(240, 240, 240)
txt.TextWrapped = true
txt.TextXAlignment = Enum.TextXAlignment.Center
txt.TextYAlignment = Enum.TextYAlignment.Center
local yes = Instance.new("TextButton")
yes.Parent = confirm
yes.Size = UDim2.new(0.38, 0, 0, 30)
yes.Position = UDim2.new(0.08, 0, 1, -45)
yes.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
yes.TextColor3 = Color3.new(1, 1, 1)
yes.Font = Enum.Font.GothamBold
yes.TextSize = 12
Instance.new("UICorner", yes).CornerRadius = UDim.new(0, 6)
local yesStroke = Instance.new("UIStroke")
yesStroke.Parent = yes
yesStroke.Color = Config.ThemeColor
yesStroke.Thickness = 1
table.insert(allHubStrokes, yesStroke)
AddHoverGlow(yes, yesStroke)
local no = Instance.new("TextButton")
no.Parent = confirm
no.Size = UDim2.new(0.38, 0, 0, 30)
no.Position = UDim2.new(0.54, 0, 1, -45)
no.BackgroundColor3 = Color3.fromRGB(55, 60, 75)
no.TextColor3 = Color3.new(1, 1, 1)
no.Font = Enum.Font.GothamBold
no.TextSize = 12
Instance.new("UICorner", no).CornerRadius = UDim.new(0, 6)
local noStroke = Instance.new("UIStroke")
noStroke.Parent = no
noStroke.Color = Config.ThemeColor
noStroke.Thickness = 1
table.insert(allHubStrokes, noStroke)
AddHoverGlow(no, noStroke)
closeBtn.MouseButton1Click:Connect(function()
    txt.Text = "Do you want to close FishHub?"
    yes.Text = "Yes"
    no.Text = "No"
    confirm.Visible = true
end)
yes.MouseButton1Click:Connect(function() gui:Destroy() end)
no.MouseButton1Click:Connect(function() confirm.Visible = false end)
hideBtn.MouseButton1Click:Connect(function()
    CloseGUI()
    SyncToplineState()
end)
local function LoadSettingsController()
    if SettingsController then
        return SettingsController
    end

    if SettingsLoadAttempted then
        return nil
    end

    SettingsLoadAttempted = true

    local ok, result = pcall(function()
        local source = game:HttpGet(SETTINGS_URL)
        if type(source) ~= "string" or #source < 20 then
            error("setting.lua URL returned empty/invalid source")
        end

        -- setting.lua is a Module-style chunk:
        -- loadstring(source) -> chunk
        -- chunk()             -> factory
        -- factory(context)    -> controller
        local chunk, compileError = loadstring(source)
        if type(chunk) ~= "function" then
            error("setting.lua compile error: " .. tostring(compileError))
        end

        local factory = chunk()
        if type(factory) ~= "function" then
            error("setting.lua must return a factory function")
        end

        local controller = factory({
            Players = Players,
            UserInputService = UserInputService,
            TweenService = TweenService,

            gui = gui,
            main = main,
            mainScale = mainScale,
            Config = Config,

            allHubStrokes = allHubStrokes,
            allHubLines = allHubLines,
            allThemeTexts = allThemeTexts,

            mainStroke = mainStroke,
            glowBorder = glowBorder,
            openStroke = openStroke,
            openGlow = openGlow,
            openAccent = openAccent,
            openStatus = openStatus,
            openIcon = openIcon,
            lineStroke = lineStroke,

            contentHoverRegistry = contentHoverRegistry,
            tabButtons = tabButtons,
            CONTENT_BORDER_COLOR = CONTENT_BORDER_COLOR,
            getActiveTabName = function()
                return activeTabName
            end,

            loadingScreen = loadingScreen,
            progressFill = progressFill,
            loadingStatus = loadingStatus,
            THEME_LOADING_APPLY_DELAY = THEME_LOADING_APPLY_DELAY,

            PlayAdvancedThemeLoading = PlayAdvancedThemeLoading,
            StopLoadingAnimation = StopLoadingAnimation,
            RestoreUIAfterThemeLoading = RestoreUIAfterThemeLoading,
            FinishAdvancedThemeLoading = FinishAdvancedThemeLoading,
            UpdateLoadingTheme = UpdateLoadingTheme,
            ShowNotification = ShowNotification,

            isThemeLoading = function()
                return themeLoadingActive == true
            end,
            getLoadingAnimationToken = function()
                return loadingAnimationToken
            end,
            setThemeLoading = function(value)
                themeLoadingActive = value == true
            end,

            debugSidebarFrame = debugSidebarFrame,
            keyStatusSidebarFrame = keyStatusSidebarFrame,
            debugDividerBetween = debugDividerBetween,

            gearBtn = gearBtn,
        })

        if type(controller) ~= "table" then
            error("setting.lua initialized but did not return a controller table")
        end

        return controller
    end)

    if not ok or type(result) ~= "table" then
        local reason = tostring(result)
        warn("[FishHub] setting.lua failed to load: " .. reason)
        SettingsLoadAttempted = false
        pcall(function()
            ShowNotification("Settings load failed: " .. reason)
        end)
        return nil
    end

    SettingsController = result
    return SettingsController
end

gearBtn.Activated:Connect(function()
    local controller = LoadSettingsController()
    if controller then
        controller:Toggle()
    end
end)
OpenGUI()
